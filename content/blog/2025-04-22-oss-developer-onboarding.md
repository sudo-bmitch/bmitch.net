---
date: '2025-04-22'
draft: false
title: 'OSS Developer Onboarding'
showToc: false
TocOpen: false
categories: ["blog"]
tags: ["open source"]
---

Open Source Software (OSS) has an onboarding and a retention problem.
These problems are connected, but it's not clear which is the cause versus the effect.

Much of this is based on a conflict of goals and personalities between the different types of OSS contributors.

## Student

The student is looking to leverage their OSS contributions as part of their eduction and to enhance their resume.
Students tend to ask for lots of support from maintainers because they are frequently not users of the project and don't understand how the project works or why it is designed the way it is.
Additionally, they will frequently shotgun their requests to lots of projects, quickly abandon any project where they work seems too difficult or the maintainers are too slow to respond.
And once they have content for their resume, or credit in their course, they quickly vanish.

While the student may get bragging rights for being an OSS contributor, to the projects, they tend to be a burden.
The maintainer's effort to guide the student is undertaken in the hopes that they turn into a long term contributor.
And the deliverable they provide could often be done by the maintainers themselves in less time and effort if the student did not distract them from their work.

## One-Off Contribution

A common entry point into the OSS ecosystem is from software professionals that see a problem with an OSS tool they use and they contribute a fix.
They may need guidance on how to contribute to the specific project, but they already have a general understanding of software development and the functionality of the project.

These tend to be low overhead for maintainers to support.
The contributor isn't looking for a "good first issue" from the maintainer.
And the contributor is unlikely to ghost the maintainer if they aren't immediately responsive.
In some cases, these one-off contributors can turn into regular contributors or even maintainers.

## Silicon Valley Business Model

There's been a business model in Silicon Valley to use OSS offerings to attract a user base, and then attempt to convert those users into paying customers.
The past few years have been full of rug-pulls that have removed trust in corporate backed OSS projects, particularly any project that requires a Contributor License Agreement (CLA) to be signed.

Contributors often find that these projects are not interested in reviewing PRs from anyone outside of the company.
Contributions that threaten monetization plans will be rejected.
In the overall OSS ecosystem, these projects violate the spirit of the OSS development model, and are attempting to exploit the community rather than grow it.

## Software Standard Business Model

Some software companies depend on functionality from major OSS projects, and so they contribute to the project to ensure it aligns with their business goals.
This is frequently seen with large projects like Linux and Kubernetes where companies have a business interest in the development path of the project, even if they do not make money directly from it.

These projects tend to be very large, visible, and highly reported on.
As a result, when someone thinks of an OSS project, they think of one of these.
However, they do not represent the majority of OSS development models, and structures that work for them will not apply the the long tail of single maintainer hobby projects.

These projects have an intentional barrier to entry, due to their size and importance.
For a new contributor trying to break into OSS development, these projects may show up at the top of their search, but they should be the last project anyone attempts to contribute to, waiting until after they have experience in the ecosystem.

## Other Business Models

OSS itself is not a business model, but lots of people try to include it in their business models.
This includes projects that sell support contracts, companies that sell hardware that runs on OSS, educators, and even individuals that request donations.

Where profit motives and OSS meet, there is often conflict.
Maintainers may not want to add features that threaten their income.
A project that is too well documented or easy to use may not generate support contracts.
An open-core business model will reject features that compete with their paid offerings.
Educators that release some of their course material will reject changes that do not align with the courses they are teaching.
And individuals that request donations may intentionally delay fixes to anyone that does not donate.

While everyone deserves to earn a living, we should recognize that this conflict is not a healthy state for OSS projects.

## Public Good

Various government agencies, grant recipients, and similar, have a requirement to release their work with an OSS license.
Maintainers of these projects have a unique position of getting paid to contribute to OSS without any expectation of generating a revenue from the OSS contributions.

The result of this is that maintainers will frequently limit their work to the minimum requirements.
For them, OSS may be a checkbox to get their funding rather than a goal to create a shared project and community contributing to that project.

Students are often exposed to this model early since it may be the model their professors know.
The unfortunate result of this model is that projects are either inaccessible to external contributors, where OSS is only used as a required public disclosure, or the project ends as soon as the grant runs out.
The effort to grow OSS using these models can have the opposite effect, increasing the number of inaccessible or unmaintained projects.

## Hobbyist

The hobbyist contributes to OSS in their personal time, without any expectation of earning a living from their work.
This is the exception to all of the other personalities, but also the very long tail of single maintainer projects that have been triggering so many alarms by those looking at the OSS ecosystem.

These maintainers are often happy to accept contributions, but they may not have the time to guide contributors.
The growth in maintainers to the project, frequently returns to one, if not zero, as there are far more projects than there are people with free time to maintain them all.
People naturally change their interests over time, and have other commitments that prevent them from continuing to maintain a project indefinitely.
So the long term viability of a project depends on being the exception to the rule, forming a community that grows faster than the maintainer attrition.

For the hobbyist, community building and software development are two very different skill sets.
Solving the onboarding and retention challenge in OSS requires that we find ways to build these communities with maintainers that only want to focus on their software development skills.

## Hacker

Unfortunately, not all OSS contributors are benevolent.
Some are looking to use OSS as a way to get others to run their malicious code, perhaps as a bad PR to a project, taking over maintenance of a project, or creating a new project that looks trustworthy.
As we look at solutions to OSS onboarding and retention, we need to ensure we are not creating an ecosystem that is more vulnerable to attack.

## Conflicts of Interest

Between all of these personalities are lots of conflicting goals.
A contributor looking to add their feature to a project run by a for-profit company often discovers they are ignored.
A student that is just learning about OSS development is not ready to become a Linux kernel contributor.
And the hobbyist are getting burned out trying to distinguish between a student, one-off contribution, or a hacker trying to coop their project.

Given these conflicts, it's no surprise that onboarding in OSS frequently fails.
And the maintainers going through these bad experiences eventually decide to abandon their project, finding their joy elsewhere.

## Solutions

So how do we improve the ecosystem?

1. First, verify it really is broken.
   There are concerns raised around OSS conferences being full of older individuals.
   But that is missing that retirees are a common source of hobby maintainers, and one of the few types of contributors with the time, money, and interest to attend a conference.
   We can't assume the conference demographic aligns with the overall OSS ecosystem demographic.
1. Accept that effort should not be put into onboarding some contributors.
   Students will be gone as soon as their PR lands as they get the credit on their resume.
   And hackers looking for their next supply chain attack need to be blocked.
1. Realize that solutions targeting one personality will not work for others.
   Lots of work is being put into improving the large OSS projects that already have hundreds of contributors and corporate sponsors.
   This just doesn't apply to the vast majority of OSS projects.
1. Document and automate the onboarding.

The last one is where I think the most work is needed.
Guidelines for creating an OSS project focus on selecting a license, structuring the code, configuring CI gates for code quality, but far too little focus is given on how to guide new contributors.
Those new contributor paths should focus on self-directed activities, with guardrails, that minimize the time required for maintainers.

When programming, regression tests help prevent us from making the same mistake again.
When solving a bug, we add tests as our guardrail, saving us time in the future.
That philosophy can be used in the onboarding experiencing, improving the process every time the maintainer or contributor has a bad experience.

That may involve improving the contributor guide to walk users through the process of building the project locally, and how to run the tests and other CI checks before submitting the PR.
Or perhaps it is just being honest with the users, letting them know this is an OSS project in license only, and that contributions are not accepted.
If you have a policy against LLM generated PRs, make sure that is clearly documented.
Every time something goes wrong is an opportunity to add a check to avoid repeating the same headaches.

One last consideration, from the perspective of access to maintainers, consider limiting that access based on how much someone has contributed.
If someone new shows up in the project looking for maintainer guidance, they should be politely directed to the documentation explaining the process for new contributors.

And if someone has been regularly providing useful contributions, spend more time growing their involvement in the community.
Because that's the type of person you want to onboard and retain as a future maintainer.
