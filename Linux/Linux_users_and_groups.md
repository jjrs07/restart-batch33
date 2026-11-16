# Linux Users, Groups, and Administrative Access

A teaching guide for creating local accounts, organizing group membership, and using administrative privileges responsibly.

## 1. Lesson Overview and Lab Setup

**Learning goals:** Inspect account records, create and modify users, manage groups, distinguish primary and supplementary groups, and explain `su` versus `sudo`.

**Opening activity:** Before explaining terminology, ask students to run:

```bash
whoami
id
groups
```

Ask: “Which part identifies you, and which parts describe teams you belong to?” Use their actual output to introduce users, UIDs, groups, and GIDs.

**Account model:** A process runs with a user identity and group memberships. File ownership and permissions use these identities to control access. Sudo policy separately controls which commands a user may run as another identity.

**Prerequisites:** Each student uses either a Linux distribution in WSL or a Linux VM, with Bash, the usual local account-management utilities, and an existing personal Linux account authorized to use `sudo`. Use a dedicated lab environment. The student's personal account is the administrator for the exercise; `labalice` is a separate practice account. Examples showing `instructor` mean that existing administrator account, not an account students must create.

### Choose your lab environment

| Environment | How to start | Lab considerations |
| --- | --- | --- |
| Linux on WSL | Open your installed Linux distribution from Windows Terminal or the Start menu. | Run Linux commands inside the distribution. Linux users and groups are separate from Windows accounts. Systemd and log availability depend on setup. |
| Linux VM | Sign in through the VM console or SSH using your existing Linux account. | A VM more closely reproduces a standalone server's startup and login behavior. Take a snapshot before the lab if supported. |

WSL is convenient for local command practice; a VM is useful for practicing the complete server lifecycle. Both support the core local-user and group exercises here.

**Preflight — run inside Linux, not PowerShell:**

```bash
cat /etc/os-release
whoami
id
sudo -l
ps -p 1 -o comm=
cd ~
```

These commands identify the distribution, current account, sudo permissions, and PID 1 process, then move to your Linux home directory. If PID 1 is `systemd`, try the journal-based logging activity later. Otherwise, treat that activity as conditional. Core user/group exercises do not require systemd. In WSL, keep practice data in the Linux home directory rather than a Windows-mounted path such as `/mnt/c`.

If `whoami` reports `root`, switch to your existing non-root, sudo-enabled account before starting. Ask the instructor to help with initial account setup if needed. Do not delete or rename your default WSL user, VM login, or other existing accounts.

References: [Microsoft WSL commands](https://learn.microsoft.com/en-us/windows/wsl/basic-commands), [systemd in WSL](https://learn.microsoft.com/en-us/windows/wsl/systemd).

### Check practice account names

Examples use `labalice`, the private group `labalice`, and the shared group `labteam`. Check that these names are unused before starting:

```bash
getent passwd labalice
getent group labalice
getent group labteam
```

No output normally means no matching entry. An unexpected error requires investigation. These are local-account exercises; directory-managed identities should be changed through their identity provider.

**Lab flow:** Inspect → create → modify → verify → demonstrate elevation → clean up. Run the main examples in order; option tables are references, not a script to execute in full.

> Commands using `sudo` change system state unless labeled as inspection. Outputs are illustrative; IDs, messages, paths, and defaults vary. Successful account-management commands often print nothing. Never use your own login account for deletion exercises.

## 2. Understanding User Accounts

### `/etc/passwd` — Local account records

Each line has seven colon-separated fields. Despite its name, this file normally does not contain password hashes; those are held in the restricted `/etc/shadow` file.

```text
username:password:UID:GID:comment:home:shell
labalice:x:1001:1001:Lab Alice:/home/labalice:/bin/bash
```

| Field | Meaning in the example |
| --- | --- |
| Username | `labalice`: account name. |
| Password | `x`: password hash is stored separately in `/etc/shadow`. |
| UID | `1001`: numeric user identity; UID `0` is root. |
| GID | `1001`: numeric primary group identity. |
| Comment / GECOS | `Lab Alice`: descriptive account information. |
| Home | `/home/labalice`: home directory path. |
| Shell | `/bin/bash`: login shell. |

**Inspection commands:**

| Command | Description | Example result |
| --- | --- | --- |
| `getent passwd labalice` | Queries the configured account databases, including local files and configured directory services. | The account record above, once created. |
| `grep '^labalice:' /etc/passwd` | Searches the local account file only. | The local record above. |
| `id labalice` | Shows a user's UID, primary GID, and group memberships. | `uid=1001(labalice) gid=1001(labalice) groups=1001(labalice)` |

Reference: [passwd file format](https://man7.org/linux/man-pages/man5/passwd.5.html).

### `useradd` — Create a local user

**Instructor demo:** Create a home directory, private primary group, and Bash login shell explicitly.

```bash
sudo useradd -m -U -s /bin/bash -c 'Lab Alice' labalice
getent passwd labalice
ls -ld /home/labalice
```

Sample verification output:

```text
labalice:x:1001:1001:Lab Alice:/home/labalice:/bin/bash
drwx------. 2 labalice labalice 4096 Nov 14 09:30 /home/labalice
```

Permissions and IDs vary. `useradd` normally produces no success message. Without setting a password, password authentication is normally locked; other authentication methods depend on configuration.

| Option | Description | Example fragment |
| --- | --- | --- |
| `-m` | Creates the home directory, copying skeleton files. | `-m` |
| `-U` | Creates a group with the same name as the user. | `-U` |
| `-c` | Sets the account comment. | `-c 'Lab Alice'` |
| `-d` | Sets the home path; use `-m` to create it. | `-m -d /home/labalice` |
| `-e` | Sets the account expiration date in `YYYY-MM-DD` format. | `-e 2099-12-31` |
| `-s` | Sets the login shell. | `-s /bin/bash` |
| `-g` | Selects an existing primary group instead of creating a private one. | `-g labteam` |
| `-G` | Assigns supplementary groups that already exist. | `-G labteam` |

Choose an appropriate future expiration date for a real temporary account. Account expiration differs from password expiration.

Reference: [useradd options](https://man7.org/linux/man-pages/man8/useradd.8.html).

### `passwd` — Set or change a password

An administrator can set another user's password:

```bash
sudo passwd labalice
```

Sample interaction:

```text
New password:
Retype new password:
passwd: all authentication tokens updated successfully.
```

Passwords are not echoed. Follow the lab's password policy; never put passwords directly in command arguments or teaching screenshots.

| Command | Description | Expected result |
| --- | --- | --- |
| `passwd` | Changes your own password, subject to authentication and policy. | Prompts for current and new passwords as applicable. |
| `sudo passwd labalice` | Sets the lab user's password. | Prompts for the new password twice. |
| `sudo passwd -S labalice` | Inspects password status. | A status line; `P` indicates a usable password hash, `L` a locked password, `NP` no password. |
| `sudo passwd -l labalice` | Locks password authentication. | A confirmation message; other methods such as SSH keys may still work. |
| `sudo passwd -u labalice` | Unlocks a previously locked password, if permitted. | A confirmation or diagnostic message. |

Password locking alone is not complete account deactivation and does not terminate existing sessions.

Reference: [passwd command](https://man7.org/linux/man-pages/man1/passwd.1.html).

### `usermod` — Modify an existing user

Change the description and inspect the result:

```bash
sudo usermod -c 'Lab Alice - Cloud Operations' labalice
getent passwd labalice
```

Sample output:

```text
labalice:x:1001:1001:Lab Alice - Cloud Operations:/home/labalice:/bin/bash
```

| Option | Description | Example |
| --- | --- | --- |
| `-c` | Changes the comment. | `sudo usermod -c 'Lab Alice' labalice` |
| `-e` | Sets account expiration. | `sudo usermod -e 2099-12-31 labalice` |
| `-e ''` | Removes account expiration. | `sudo usermod -e '' labalice` |
| `-d` with `-m` | Changes the home path and moves its contents. | `sudo usermod -d /home/labalice-new -m labalice` |
| `-g` | Changes the primary group to an existing group. | `sudo usermod -g labteam labalice` |
| `-aG` | Appends supplementary groups. | `sudo usermod -aG labteam labalice` |
| `-s` | Changes the login shell. | `sudo usermod -s /bin/bash labalice` |

Use home-move examples only as a separate exercise while the user is logged out. Applications may still reference the old path.

> `usermod -G labteam labalice` replaces the supplementary group list. Include `-a` when adding membership without removing existing groups.

Reference: [usermod options](https://man7.org/linux/man-pages/man8/usermod.8.html).

## 3. Understanding and Managing Groups

A group collects users under one identity for access management. A user has one primary group and may have multiple supplementary groups. Membership grants access only where permissions or policy allow it.

### `/etc/group` — Local group records

```text
group_name:password:GID:member_list
labteam:x:1002:labalice
```

| Field | Description |
| --- | --- |
| Group name | `labteam`: human-readable name. |
| Password | `x`: conventionally indicates a shadowed group password field; group passwords are not used in this lesson. |
| GID | `1002`: numeric group identity. |
| Member list | Comma-separated supplementary members, such as `labalice,labbob`. |

Primary membership comes from the user's GID in the account record; primary members need not appear in this list. Use `id labalice` to inspect both kinds of membership.

Reference: [group file format](https://man7.org/linux/man-pages/man5/group.5.html).

### `groupadd` — Create a group

```bash
sudo groupadd labteam
getent group labteam
```

Sample output:

```text
labteam:x:1002:
```

The empty final field means no explicitly listed supplementary members. `groupadd` itself is normally silent. Optional `-g GID` selects a unique numeric GID, for example `sudo groupadd -g 2500 labproject`, after checking that both the name and GID are unused.

Reference: [groupadd](https://man7.org/linux/man-pages/man8/groupadd.8.html).

### Add membership with `usermod`

```bash
sudo usermod -aG labteam labalice
id labalice
```

Sample output:

```text
uid=1001(labalice) gid=1001(labalice) groups=1001(labalice),1002(labteam)
```

`-a` appends; `-G` specifies supplementary groups. Multiple groups use commas without spaces. Existing sessions keep their current process credentials; start a fresh login to use new memberships. `id labalice` queries account information, whereas `id` shows the current process's identities.

For either WSL or a VM, use `su - labalice` after setting its password to open a fresh practice-user shell. Run `id`, then `exit` to return to your administrator account. If already inside a `labalice` shell when membership changes, exit it and start a new one. Opening another terminal as your usual account does not switch it to `labalice`.

### `gpasswd` — Manage group membership

Despite its name, this command can add or remove members without setting a group password.

| Option | Description | Example |
| --- | --- | --- |
| `-a USER GROUP` | Adds one supplementary member. | `sudo gpasswd -a labalice labteam` |
| `-d USER GROUP` | Removes one supplementary member. | `sudo gpasswd -d labalice labteam` |
| `-M USER,... GROUP` | Replaces the complete explicit member list. | `sudo gpasswd -M labalice labteam` |
| `-A USER,... GROUP` | Sets the group administrator list; administrative operation. | `sudo gpasswd -A labalice labteam` |

**Demo:** Remove and restore membership:

```bash
sudo gpasswd -d labalice labteam
sudo gpasswd -a labalice labteam
getent group labteam
```

Sample output:

```text
Removing user labalice from group labteam
Adding user labalice to group labteam
labteam:x:1002:labalice
```

Use `-M` and `-A` only as separate instructor examples: they replace lists. Group administrators can manage that group's membership; this does not make them root. `gpasswd -d` does not change a user's primary group.

Reference: [gpasswd](https://man7.org/linux/man-pages/man1/gpasswd.1.html).

### `groupmod` — Modify a group

An optional rename exercise; rename back so later examples continue to work:

```bash
sudo groupmod -n labcloud labteam
getent group labcloud
sudo groupmod -n labteam labcloud
```

Sample output from the inspection:

```text
labcloud:x:1002:labalice
```

`-n` changes the name while keeping the GID. `-g NEW_GID` changes the numeric GID. A GID change requires reviewing existing files and correcting their group ownership separately; it is not part of this lab.

Reference: [groupmod](https://man7.org/linux/man-pages/man8/groupmod.8.html).

## 4. Root, Standard Users, and Prompts

| Topic | Root user | Standard user |
| --- | --- | --- |
| Identity | UID `0`. | Nonzero UID; not every nonzero account is a human login. |
| Access | Broad system administration privileges, subject to controls such as SELinux and container boundaries. | Limited by ownership, permissions, and security policy. |
| Elevation | Already privileged. | Can use `sudo` only where policy authorizes it. |
| Typical prompt | Ends with `#`. | Ends with `$`. |
| Error impact | Can affect the whole system. | Usually limited to resources the user can access. |

```console
[instructor@linux-lab ~]$ whoami
instructor
[root@linux-lab ~]# whoami
root
```

Prompts can be customized. Verify identity with `id` or `whoami`; do not trust a prompt symbol alone.

**Teaching point:** Prefer a named standard account with command-specific elevation for accountability. A persistent root shell is convenient for extended administration but increases the scope of mistakes and makes individual-command attribution harder without additional auditing. Keep root shells brief, verify paths before destructive actions, and use `exit` when finished. Avoid shared root credentials, broad passwordless rules, and routine direct root login.

## 5. `su` and `sudo`

### `su` — Switch user identity

```bash
su - labalice
whoami
pwd
exit
```

Sample interaction and output:

```text
Password:
labalice
/home/labalice
```

`su - labalice` starts a login shell for the target user. Authentication normally requires the target user's password, subject to PAM policy. `exit` returns to the previous shell.

| Command | Description |
| --- | --- |
| `su labalice` | Switches identity without requesting a full login environment; typically retains the working directory. |
| `su - labalice` | Switches identity and initializes a login environment and home directory. |
| `su -` | Requests a root login shell; normally needs root authentication. |
| `su - labalice -c 'whoami'` | Runs one command as the target user, then returns; output: `labalice`. |

A locked root password can prevent password-based `su -`; cloud images often expect administration through `sudo` instead. Do not enable a root password just to complete this lesson.

Reference: [su](https://man7.org/linux/man-pages/man1/su.1.html).

### `sudo` — Run an authorized command as another user

```bash
whoami
sudo whoami
whoami
```

Sample output, with an authentication prompt omitted:

```text
instructor
root
instructor
```

The command runs as root by default, then control returns to your shell. Authentication normally uses the invoking user's credentials; policy may allow passwordless use or change authentication behavior.

| Command | Description | Expected result |
| --- | --- | --- |
| `sudo -l` | Lists your allowed commands. | Policy-dependent privilege list. |
| `sudo -u labalice whoami` | Runs as the named user if authorized. | `labalice` |
| `sudo -i` | Starts a root login shell if authorized. | Root shell; leave with `exit`. |
| `sudo -k` | Invalidates cached sudo authentication. | Normally silent; later authentication depends on policy. |

Reference: [sudo project manual](https://github.com/sudo-project/sudo/blob/main/docs/sudo.man.in).

### `/etc/sudoers` — Administrative authorization policy

This policy defines who may run which commands, on which hosts, and as which users/groups. Additional rules may be loaded from `/etc/sudoers.d/` when configured.

Example for discussion, assuming `/usr/bin/id` is the installed path:

```sudoers
labalice ALL=(root) /usr/bin/id
```

This allows `labalice` to run that command as root. It grants no other commands by itself; other matching rules may grant more. Broad rules using `ALL` for commands confer much greater power. Groups named `wheel` on many RHEL-family systems or `sudo` on many Debian-family systems commonly receive administrative access through policy; the group name alone grants nothing.

**Optional instructor-only policy exercise:** Check `command -v id`, confirm the include-directory configuration, and keep a known-good administrator session open. Use `sudo visudo -f /etc/sudoers.d/labalice-lab` to create the example rule, then validate the complete policy:

```bash
sudo visudo -c
```

Typical output includes:

```text
/etc/sudoers: parsed OK
/etc/sudoers.d/labalice-lab: parsed OK
```

`visudo` checks syntax and coordinates editing. Never force-save invalid policy. Test permitted and denied behavior from a separate lab-user session before closing the administrator session. Syntax validation does not prove least privilege.

References: [sudoers policy](https://github.com/sudo-project/sudo/blob/main/docs/sudoers.man.in), [visudo](https://www.man7.org/linux/man-pages/man8/visudo.8.html).

### Sudo logs — Inspect administrative activity

Sudo can log allowed and denied command events. Destination and retention depend on configuration. Command-event logging does not automatically record every action inside an elevated shell; I/O recording requires separate configuration.

On WSL or a VM where PID 1 is `systemd` and journal logging is available, try:

```bash
sudo journalctl _COMM=sudo --since '10 minutes ago' --no-pager
```

Sample event excerpt:

```text
instructor : TTY=pts/0 ; PWD=/home/instructor ; USER=root ; COMMAND=/usr/bin/whoami
```

Where file-based authentication logging is configured, inspect the applicable file:

```bash
# Common on RHEL-family systems with suitable syslog configuration:
sudo tail -n 20 /var/log/secure

# Common on Debian-family systems with suitable syslog configuration:
sudo tail -n 20 /var/log/auth.log
```

These files may be absent, and the journal filter may return no entries. Check logging configuration and retention before concluding that no command ran. Treat logs as sensitive.

**Student lab rule:** If your WSL distribution or minimal VM has no applicable logging service or records, document the logging activity as unavailable in that environment. Complete `sudo -l` and the identity demonstration instead. Enabling systemd or installing a logging service is a separate instructor-led setup task, not required for this account-management exercise.

Reference: [sudoers event and I/O logging](https://github.com/sudo-project/sudo/blob/main/docs/sudoers.man.in).

### `su` versus `sudo`

| Question | `su` | `sudo` |
| --- | --- | --- |
| Main use | Switch identity, commonly into a shell. | Run a policy-authorized command as another identity. |
| Usual password | Target user's password. | Invoking user's password, unless policy differs. |
| Root by default? | Yes, when no target is given. | Yes, unless another target/default is configured. |
| Single-command example | `su - labalice -c 'whoami'` | `sudo -u labalice whoami` |
| Authorization model | Authentication and PAM/account restrictions. | Sudo policy controls allowed targets and commands. |
| Audit detail | Authentication/session events depend on configuration. | Command events depend on configuration; shell internals need additional auditing. |

**Discussion:** Why would an organization prefer named accounts and narrow sudo rules over sharing a root password?

## 6. Deletion and Lab Cleanup

Run these only after the teaching activities. Review lab-created data first and ensure `labalice` has no active sessions or processes. Do not force deletion to bypass an active-user warning.

### `userdel` — Delete a local account

| Command | Description | Expected result |
| --- | --- | --- |
| `sudo userdel labalice` | Removes the account while normally retaining the home directory. | Usually no output; home data remains. |
| `sudo userdel -r labalice` | Removes the account, home directory, and mail spool. | Usually no output; may report absent resources. |

These are alternatives. For disposable lab cleanup, use the second only after reviewing the home directory:

```bash
sudo userdel -r labalice
getent passwd labalice
```

The lookup should return no matching record. Files elsewhere are not automatically removed; inspect retained ownership by numeric UID before that UID is reused. Private-group removal depends on configuration.

Reference: [userdel](https://man7.org/linux/man-pages/man8/userdel.8.html).

### `groupdel` — Delete a local group

```bash
sudo groupdel labteam
getent group labteam
```

Normally the deletion is silent and the lookup returns no matching record. Deleting a group does not delete users or its files. Normally, a group cannot be deleted while it is a user's primary group. Reassign primary membership first. Review file ownership before reusing its GID.

If the optional sudoers exercise was performed, use `sudo visudo -f /etc/sudoers.d/labalice-lab` to remove its rule, then run `sudo visudo -c`. Check whether the private `labalice` group remains; delete it only if it belongs exclusively to this lab and is no longer needed.

Reference: [groupdel](https://man7.org/linux/man-pages/man8/groupdel.8.html).

## 7. Student Practice and Knowledge Checks

Before cleanup, have students perform these tasks and explain their verification:

1. Show the UID, primary group, and supplementary groups of `labalice`.
2. Change the account comment and confirm the record changed.
3. Remove and restore `labteam` supplementary membership without affecting other groups.
4. Explain why the group file may omit a user's primary membership.
5. Explain what can happen if `-a` is omitted from `usermod -aG`.
6. Compare `whoami` and `sudo whoami`, then identify the original user in a sudo log event if logging is available.
7. Explain which data `userdel -r` removes and which data it can leave behind.

## 8. Troubleshooting and Validation

| Symptom | Investigation |
| --- | --- |
| User or group already exists | Inspect with `getent passwd NAME` or `getent group NAME`. Use distinct lab names; do not delete an unknown account. |
| Permission denied | Confirm identity with `id` and authorization with `sudo -l`. |
| User is not allowed to run sudo | Return to your existing sudo-enabled Linux account. `labalice` is intentionally unprivileged unless explicitly delegated. Ask the instructor if your personal account lacks the required authorization. |
| Group change not reflected in a running shell | Compare `id labalice` with `id` inside that shell; start a fresh login. |
| Password-based login fails | Check password status, account expiration, shell, PAM policy, and the login method's configuration. |
| Group deletion fails | Check whether any user still has that primary GID. |
| No sudo log entries | Check logging destination, permissions, time range, filters, and retention. |
| Linux command fails in PowerShell | Open the Linux distribution or VM terminal and run it there. PowerShell is not the Bash environment used in this guide. |
| `journalctl` reports that systemd is not running | Check `ps -p 1 -o comm=`. Follow the conditional logging instructions; core account-management tasks can continue. |
| Command option differs | Consult the installed manual, such as `man usermod` or `man sudoers`. |

**Validation status:** Reviewed against upstream project manuals and Microsoft WSL documentation. Sample outputs are illustrative; this document has not been exercised in a live WSL distribution or Linux VM. No local or remote accounts were changed while preparing it.
