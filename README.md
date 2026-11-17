# AWS re/Start — Batch 33

Supplementary hands-on labs and Linux learning guides for AWS re/Start Batch 33 students. Use these resources to practice Linux fundamentals, explore AWS services, and check your understanding as you go.

This is a working repository. New labs and updates will be added as the class progresses. Check the index below for the available activities and follow each guide for its specific requirements.

## Available Labs and Guides

| Lab or guide | What you will practice | Tools |
|---|---|---|
| [Amazon S3 Hands-On Walkthrough](s3-lab/README.md) | Bucket naming, uploading objects, versioning, encryption, access control, presigned URLs, lifecycle rules, and cleanup | AWS Management Console |
| [Navigating the Linux File System](Linux/navigating-linux-file-system/README.md) | Absolute and relative paths, navigation shortcuts, reading files, and copying with paths | Linux shell on WSL, EC2, or a lab machine |
| [Linux Command Quick Reference](Linux/Linux_command.md) | Command prompts, important Linux files, common commands, standard input/output, and redirection | Linux terminal with Bash |
| [Linux Users, Groups, and Administrative Access](Linux/Linux_users_and_groups.md) | Local users and groups, account management, root privileges, `su`, `sudo`, and cleanup | Linux on WSL or a Linux VM; an existing sudo-enabled account |
| [EC2 SSH Connection Guide](Linux/EC2_SSH_connection_guide.md) | Protect an EC2 private key on macOS, Linux, and Windows; connect with SSH and troubleshoot permissions | Terminal, Windows OpenSSH, or PuTTY |

## Getting Started

1. Open a lab or guide from the table above.
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

1. Create a folder with a descriptive name, such as `<topic>-lab`.
2. Add a `README.md` for a lab or a descriptive Markdown filename for a guide, with objectives, prerequisites, instructions, and cleanup steps where applicable.
3. Add a row to the **Available Labs and Guides** table above, linking directly to the new resource.

Keep resource-specific setup details in its guide so this page remains a general entry point for the collection.

## Questions or Corrections

If a step is unclear or you spot an error, [open an issue](https://github.com/jjrs07/restart-batch33/issues) with the lab name, step number, and what happened. Keep passwords, access keys, and other credentials out of screenshots and reports.
