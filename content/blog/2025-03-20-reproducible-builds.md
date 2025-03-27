---
date: '2025-03-20'
draft: false
title: 'Reproducible Builds'
showToc: false
TocOpen: false
categories: ["blog"]
tags: ["security", "reproducible builds"]
---

Reproducible builds are an idealistic solution to many supply chain security challenges I see today.
They eliminate an entire chain of attacks, from a compromised build infrastructure (see SolarWinds) to a compromised artifact distribution.
But they are only a piece of the solution, and they are rarely implemented today.
Here's my take on what a complete solution would look like, and why no one is doing it.

## Theoretical Solution

An end-to-end solution needs multiple checks at each point along the software deliver path.
The goal is to eliminate any single point that can be compromised in the build pipeline.

1. **Source:** We need to clearly identify the source being built.
   This needs to be identified by an immutable hash (e.g. a git sha) and that hash needs signed attestations.
   Those attestations need to identify who produced the code, who reviewed it, and they are needed for the entire chain of commits in the source repository.

2. **Dependencies:** Every dependency needs to be vendored, or at least pinned to a hash (not a mutable version pointer).
   Ideally the builds will run in a hermetic environment, which requires vendoring.
   But at a minimum, every imported dependency should not be able to change between builds.

3. **Builders:** Multiple builders need to be run against these inputs.
   The builders need to scan all of the inputs for malicious content and security flaws.
   A single builder may output the binary artifact, but each one needs to output a signed attestation indicating the source built and the resulting binary hash.

4. **Deployment:** Deployment tooling, and anything consuming those artifacts, need to verify multiple trusted attestations are available from independent sources for the artifact.

## Current Tooling State

Most reproducible build implementations now are focused on a single part of the builder step.
They are creating a simple builder that can be used to **monitor** for a compromise, where an end-to-end solution could **prevent** a compromise.

Looking through the full ecosystem shows a lot of opportunities to improve:

1. **Source:** Attesting commits in source code just isn't done.
   At most, we sign our commits, and we track reviews inside of custom tooling.
   Even then, a vast majority of projects are managed by a single maintainer without an independent review of the changes.
   Generating, distributing, and consuming the commit attestations is going to take some development effort.

2. **Dependencies:** Pinning dependencies is getting much better within languages.
   However, complex applications tend to have build dependencies, and they output an artifact that is more than a single binary, e.g. a container image.
   Build dependencies, e.g. curl and make, tend to be pinned to a version number at best.
   Container images that include an `apt update` or `apk add` pulling in the latest release are ingesting a moving target.
   Some of this is solved by running builds inside of a pre-built container, and pinning the digest of that container image.

3. **Builders:** The ecosystem is full of builders, particularly from the various CI/CD implementations and self hosted options.
   However, many of these builders are not reproducible by default.
   This requires a lot of work by developers to make the build tooling reproducible, often done by running the build inside of pinned containers.
   If you've never tried to build a reproducible artifact, let me just say that timestamps are everywhere.

   Scanning for malicious content by these builders is error prone.
   There are lots of scanners, each focused on specific types of attacks, so builders should be running an array of scans to detect as many possible attacks as possible.
   A large blind spot is checking for vulnerabilities in dependencies that are outside of the language ecosystem.

   Ideally the build infrastructure would generate its own signed attestation.
   For builders that don't, reproducible build tooling needs to wrap the build in a way that isolates the build and prevents inputs from accessing signing keys or compromising the builder.
   The latter model is seen with the [SLSA GitHub generator](https://github.com/slsa-framework/slsa-github-generator).

4. **Deployment:** Deployment tooling that checks for reproducibility is lacking.
   At most, tooling exists to check signatures, but what is needed is to check for multiple independent signatures.
   This is where we change from a monitoring solution that detects a past attack, to a verification solution that prevents a new attack.

## Business Demand

Tooling is only half the reason we aren't all building artifacts reproducible builders and verifying those builds.
From a business view, this would add more than double the expense for a very small gain.

There's an added expense to implementing reproducible builders because each build multiplies the CPU time and other expenses to run the build infrastructure.
But there's also the added expense to make the builds reproducible and to debug mismatches between different build environments.
Timestamps get everywhere, new dependencies are added without pinning, and parts of the build infrastructure like filesystem paths and hostnames leak into the generated artifact.
All of this takes time and money to fix.
And in an era of moving fast and breaking things, companies budget for new features, not hardened security.

Security is seen as an expense to nearly every organization, an expense that is minimized.
The expense equation looks at the probability times the cost of a successful attack, and if that is less than the cost to implement a secure solution, companies accept that risk.

Reproducible builds are a high-cost solution to a low-risk attack.
The juice isn't worth the squeeze.

## Changing the Model

So how do we fix this?
The tooling needs to be updated to support those reproducible builds and make implementations cheaper.
This is going to take work across a lot of ecosystems.
To see some of the effort happening in this space, check out [reproducible-builds.org](https://reproducible-builds.org/).

But the other half of the equation will likely require policies from government organizations.
The push to include SBOMs in so many products was largely driven by US government policy.
The CRA (Cyber Resilience Act) in the EU is shifting the financial interest to maintain products and disclose vulnerabilities.
A government requirement for verified reproducible builds would change the financial equation that drives business decisions.

## Lets Talk Containers

In my own projects, I've been working on improving the tooling around reproducible builds for container images.
Container images are inherently non-reproducible with timestamps in the filesystem layers and in the image metadata, along with build steps that frequently ingest the latest versions of dependencies.
My [regclient](https://regclient.org) tool includes the ability to modify an image, and I've been using that to mutate timestamps to a predictable value and strip out mutable logs from the built images.

I've also taken a stab at making any build hermetic with a replayable http proxy, but work is needed to scan a recorded session and to compare a recorded session with the current state to detect malicious content.
Using this proxy requires a builder configured to isolate the network and inject a TLS certificate to MitM all of the https traffic.

This is a challenging problem that I chip away at with time, but it is going to take a lot of work from multiple ecosystems until we have a complete solution.
