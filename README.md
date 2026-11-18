# AWS re/Start — Batch 33

Supplementary hands-on labs and Linux learning guides for AWS re/Start Batch 33 students. Use these resources to practice Linux fundamentals, explore AWS services, and check your understanding as you go.

This is a working repository. New labs and updates will be added as the class progresses. Check the index below for the available activities and follow each guide for its specific requirements.

## Available Labs and Guides

| Lab or guide | What you will practice | Tools |
|---|---|---|
| [Amazon S3 Hands-On Walkthrough](s3-lab/README.md) | Bucket naming, uploading objects, versioning, encryption, access control, presigned URLs, lifecycle rules, and cleanup | AWS Management Console |
| [Linux Guides](Linux/README.md) | File system navigation, terminal commands, text editing, permissions, user administration, and SSH | See the requirements for each guide |

## Getting Started

1. Choose a lab or open the Linux guide index from the table above.
2. Read its prerequisites. For AWS labs, use the default Region assigned to your sandbox; outside the sandbox, follow the lab’s specified Region. Before creating resources, confirm the Region; for Linux guides, open the required Linux terminal or lab environment.
3. Follow the walkthrough in order and complete the checkpoints.
4. Complete any exercises or review questions included in the lab.
5. Follow any cleanup instructions before ending your session.

You can read every walkthrough directly on GitHub. To keep a local copy:

```bash
git clone https://github.com/jjrs07/restart-batch33.git
cd restart-batch33
```

If you already cloned the repository, run `git pull` from its folder before starting a new lab to get the latest updates.

## Before You Start

- For AWS labs, have access to the AWS account or training environment assigned for your class.
- For Linux guides, use the environment specified in the guide. The users and groups lab requires Linux on WSL or a Linux VM and an existing sudo-enabled account.
- Follow your instructor's guidance on which resources you may create.
- Check each lab for its required tools and permissions. When using the sandbox, stick with the default Region assigned to you; outside the sandbox, follow the lab’s specified AWS Region.
- Replace sample initials, bucket names, and dates with your own values where instructed.
- Delete resources when you finish to avoid ongoing charges.

## Adding New Labs and Guides

Group resources in a folder for their topic. Hands-on labs use a `README.md` containing their instructions and any supporting files alongside it. Linux references and lessons live in the `Linux/` folder as individual Markdown guides.

When adding a lab or guide:

1. For a standalone lab, create a descriptive folder such as `<topic>-lab` and add a `README.md`. Link the lab from the **Available Labs and Guides** table above.
2. For a Linux lesson, add a descriptive Markdown file under `Linux/` and link it from the [Linux Guides table of contents](Linux/README.md).
3. Include objectives, prerequisites, instructions, and cleanup steps where applicable.

Keep resource-specific setup details in its guide so this page remains a general entry point for the collection.

## Questions or Corrections

If a step is unclear or you spot an error, [open an issue](https://github.com/jjrs07/restart-batch33/issues) with the lab name, step number, and what happened. Keep passwords, access keys, and other credentials out of screenshots and reports.
