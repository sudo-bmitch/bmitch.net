---
date: '2025-03-20'
draft: false
title: 'Reproducible Builds'
showToc: false
TocOpen: false
categories: ["blog"]
tags: ["security", "reproducible-builds"]
---

Reproducible builds are an idealistic solution to many supply chain security challenges I see today.
They eliminate an entire chain of attacks, from a compromised build infrastructure (see SolarWinds) to a compromised artifact distribution.
But they are only a piece of the solution, and they are rarely implemented today.
Here's my take on what a complete solution would look like, and why no one is doing it.

## Theoretical Solution

1. We need to clearly identify the source being built.
   This needs to be identified by an immutable hash (e.g. a git sha) and that hash needs signed attestations.
   Those attestations need to identify who produced the code, who reviewed it, and they are needed for the entire chain of commits in the source repository.

2. Every dependency needs to be vendored, or at least pinned to a hash (not a mutable version pointer).
   Ideally the builds will run in a hermetic environment, which requires vendoring.
   But at a minimum, every imported dependency should not be able to change between builds.

3. Multiple builders need to be run against these inputs.
   The builders need to scan all of the inputs for malicious content and security flaws.
   A single builder may output the binary artifact, but each one needs to output a signed attestation indicating the source built and the resulting binary hash.

4. Deployment tooling, and anything consuming those artifacts, needs to verify multiple trusted attestations are available from independent sources for the artifact.

## Current Tooling State

So why isn't this being done already?
One reason is our current tooling.

1. Attesting commits in source code just isn't done.
   At most, we sign our commits, and we track reviews inside of custom tooling.
   Generating, distributing, and consuming these commit attestations is going to take some development effort.

2. Pinning dependencies is getting much better within languages.
   However, complex applications tend to have build dependencies, and they output an artifact that is more than a single binary, e.g. a container image.
   These build dependencies, e.g. curl and make, tend to be pinned to a version number at best.
   And every container image that includes an `apt update` or `apk add` pulling in the latest release is ingesting a moving target.
   Some of this is solved by running builds inside of a pre-built container, and pinning the digest of that container image.

3. The ecosystem is full of builders, particularly from the various CI/CD implementations and self hosted options.
   However, many of these builders are not reproducible by default.
   This requires a lot of work by developers to make the build tooling reproducible, often done by running the build inside of pinned containers.
   If you've never tried to build a reproducible artifact, let me just say that timestamps are everywhere.

   Scanning for malicious content by these builders is currently very error prone.
   There are lots of scanners, each focused on specific types of attacks, and I don't believe this will be a single solutions.
   And attackers are continuously finding new types of attacks and ways to obfuscate their malicious code injection.
   A large blind spot is checking for vulnerabilities in dependencies that are outside of the language ecosystem.

   Ideally the build infrastructure would generate its own signed attestation of what source was built, the output artifact, and the configuration of that builder.
   The alternative is to create reproducible build tooling that wraps the build in a way that isolates the build and prevents it from accessing signing keys or compromising the builder.
   The latter model is seen with the [SLSA GitHub generator](https://github.com/slsa-framework/slsa-github-generator).

4. Deployment tooling that checks for reproducibility is lacking.
   At most, tooling exists to check signatures, but what is needed is to check for multiple independent signatures.

## Business Demand

Tooling is only half the reason we aren't all building artifacts reproducible builders and verifying those builds.
From a business view, this would add more than double the expense for a very small gain.

There's an added expense to implementing reproducible builders because the builds now double the CPU time and other expenses to run a second CI/CD infrastructure.
But there's also the added expense to make the builds reproducible and to debug mismatches between different build environments.
Those timestamps get everywhere, new dependencies are added without pinning, and parts of the build infrastructure like filesystem paths and hostnames leak into the generated artifact.
All of this takes time and money to fix.
And in an era of moving fast and breaking things, companies rarely budget the time and money to implement them.

Security is also seen as an expense to nearly every organization.
And it is an expense that is minimized.
Companies add security when the cost to not implement it and suffer an attack outweighs the cost to implement it.
That first cost is a risk equation, how probable is an attack that could be prevented times the cost to implement that prevention.

In other words, the juice isn't worth the squeeze.

## Changing the Model

So how do we fix this?
The tooling needs to be updated to support those reproducible builds.
This is going to take work across a lot of ecosystems.
It has been happening, particularly in the more security conscious areas, but it is typically a lagging feature.
To see some of the effort happening in this space, check out [reproducible-builds.org](https://reproducible-builds.org/).

But the other half of the equation will likely require policies from government organizations that change the financial equation for companies.
The push to include SBOMs in so many products was largely driven by US government policy.
The CRA (Cyber Resilience Act) in the EU is shifting the financial interest to maintain products and disclose vulnerabilities.
A similar effort will eventually be needed to make the lack of reproducible builds a greater expense for companies.
And with improved tooling lowering the cost to implement reproducible builds, we may be able to turn this into a standard practice.

## Lets Talk Containers

In my own projects, I've been working on improving the tooling around reproducible builds for container images.
My [regclient](https://regclient.org) tool includes the ability to modify an image, and I've been using that to mutate timestamps to a predictable value and strip out mutable logs from the built images.
Container images are inherent non-reproducible with timestamps in the filesystem layers and in the image metadata, along with build steps that frequently ingest the latest versions of dependencies.

I've also taken a stab at making any build hermetic with a replayable http proxy, but a lot of work is needed there to scan a recorded session and compare a recorded session with the current state to detect malicious content.
Running that proxy with a container build takes work to isolate the network of the builder and inject a TLS certificate to MitM all of the https traffic.

This is a challenging problem that I chip away at with time, but it is going to take a lot of work from multiple ecosystems until we have a complete solution.
