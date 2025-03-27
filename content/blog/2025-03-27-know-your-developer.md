---
date: '2025-03-27'
title: Is Know Your Developer a Supply Chain Solution?
draft: false
showToc: false
TocOpen: false
categories: ["blog"]
tags: ["open source", "security"]
---

The financial industry has a concept of "know your customer" to prevent financial fraud.
The concept is that fraudsters do not want transactions linked back to their identity.

There's a similar push happening in Open Source security, to verify the identities of contributors before allowing their commits.
The suggestion is that this could prevent an xz style attack by requiring in person verification, such as a pgp key signing meeting.

Could this be a solution to supply chain security?

TL;DR: no.

## Bad Proxy

My opinion is that developer vetting is a bad proxy for secure and trustworthy code.
Malicious contributors often include good code in their contributions.
And good contributors can accidentally submit vulnerable code.

This bad proxy is going to have bad effects.
It will create a barrier to entry for new contributions.
It will create a false sense of trust in established contributors.
And it will create an opportunity to exclude contributions for political rather than technical reasons.

## Hit List

Good contributors can make mistakes or become compromised.
For many projects, the most prolific trusted contributors to a project are also the ones creating the most security bugs due to statistics rather than maliciousness.

If a list of trusted developers were created, one risk is that this list becomes a hit list for those looking for their next supply chain attack.
Why try to gain trust within a project when you can hijack an existing trusted identity.
An email list of trusted developers would become a high value target for attackers to send phishing attacks.

## Jia Tan Would Still Be Trusted

This change would not prevent a state actor.
They have the resources to create fake identities, and the time to build a web of trust.
They also have the resources to build a distrust in good maintainers.

In short, the headline attack this is meant to protect against is completely missed by this added layer of defense.

## Most Projects Only Have One Maintainer

A policy to verify maintainers also ignores the reality of Open Source projects.
A vast majority are maintained by a single individual, often in their spare time.
They are not the large project like the Linux kernel with corporate backing.
They do not have the time, travel resource, or corporate requirement to personally vet new maintainers.

This would have several results for this very long tail:

- Most projects would ignore the requirement.
- Maintainers would abandon their project rather than go through the effort to vet additional maintainers in person.
- Contributors will fork existing projects rather than go through the vetting process to submit their changes upstream.

These single maintainer projects are the dependencies for the rest of the ecosystem.
The effort put into hardening the large Open Source projects will end up creating a false sense of security.
Rather than attacking the large hardened projects, the long tail of single maintainer dependencies are targeted in a supply chain attack.

## Review the Code Itself

Given all those issues with a "known your developer" policy, what should we do?
**Rather than creating a proxy for secure code, we should check the code itself.**
We need a combination of vulnerability scanners, both static and dynamic analysis, and human reviews, included in the delivery pipeline.

Vulnerability scanners will need continuous improvement to adapt to a changing attack landscape.
Sandboxes should be leveraged both by scanners detecting malicious behavior, and at runtime to limit the attack surface.
The more automation we can provide to developers, the less likely a human mistake will lead to a vulnerability.

## Support the Maintainers

Lastly, don't forget to support the maintainers.
If they are accepting financial contributions, pay them so they can make this a full time job instead of a side hobby.
If they want more human support, provide staff that can review changes and submit bug fixes.
If they want to focus on the code, assist with the CI platform and hosting overhead.

Build a relationship with a project by triaging stale issues, providing reproducible examples to bug reports, and answering questions from new users.
The limiting resource for most maintainers is time, so focus on contributions that reduce the time burden on maintainers.

A project with well supported maintainers is one that has more time to focus on security, and is less likely to abandon or pass off project ownership to the most vocal stranger on the internet.
