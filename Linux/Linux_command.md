# Linux Command Quick Reference

A short guide to Linux prompts, important files, common commands, and standard input/output.

> Examples assume Bash and a regular user named `student`. Outputs are illustrative and vary by system. Use a writable practice directory for file examples. No cloud deployment is required.

## 1. Login and Command Prompts

### Login prompt

Asks for your username and password before starting a text-console session.

```text
linux-lab login: student
Password:
```

Your password is not displayed as you type. SSH login prompts can look different.

### Command prompt

Shows that the shell is ready for a command.

```console
[student@linux-lab ~]$ whoami
student
```

- `student`: username.
- `linux-lab`: hostname.
- `~`: current user's home directory.
- `$`: commonly indicates a regular user; `#` commonly indicates root. Prompts are customizable.

Type only the command after `$`, not the prompt itself.

## 2. Important Linux Files

`~` represents your home directory, such as `/home/student`.

| File | Short description | Sample command | Sample output |
| --- | --- | --- | --- |
| `/etc/passwd` | Stores local account information, including user ID, group ID, home directory, and login shell. | `grep '^student:' /etc/passwd` | `student:x:1000:1000:Student:/home/student:/bin/bash` |
| `/etc/shadow` | Stores local password hashes and password-aging settings; access is restricted. | `ls -l /etc/shadow` | `----------. 1 root root 1234 Nov 14 08:00 /etc/shadow` |
| `~/.bashrc` | Contains settings for interactive non-login Bash shells; login profiles often source it too. | `head -n 1 ~/.bashrc` | `# .bashrc` (file contents vary). |
| `~/.bash_history` | Commonly stores commands saved from earlier Bash sessions. | `tail -n 1 ~/.bash_history` | `whoami` (if that was the last saved command). |
| `~/.bash_profile` | Contains user-specific startup settings for Bash login shells. | `head -n 1 ~/.bash_profile` | `# .bash_profile` (file contents vary). |

**Notes:**

- The correct account-file path is `/etc/passwd`, rather than `/etc/.psswd`.
- The `x` in `/etc/passwd` commonly indicates that the password hash is stored in `/etc/shadow`.
- `/etc/shadow` permissions vary by distribution. Inspect its metadata for this exercise; do not expose password hashes or loosen permissions.
- After `/etc/profile`, Bash reads the first available user login file: `~/.bash_profile`, `~/.bash_login`, or `~/.profile`. Some systems therefore have no `.bash_profile`.
- History settings vary. Current-session commands may not yet be saved to `.bash_history`.

## 3. Useful Commands

| Command | Short description | Sample command | Sample output or result |
| --- | --- | --- | --- |
| `whoami` | Shows the current effective username. | `whoami` | `student` |
| `id` | Shows user and group IDs and group membership. | `id` | `uid=1000(student) gid=1000(student) groups=1000(student),10(wheel)` |
| `hostname` | Shows the system's hostname. | `hostname` | `linux-lab` |
| `uptime` | Shows running time, user sessions, and load averages. | `uptime` | `09:30:00 up 2 days, 1:15, 1 user, load average: 0.05, 0.03, 0.01` |
| `date` | Shows the system date and time. | `date '+%Y-%m-%d %H:%M:%S %Z'` | `2026-11-14 09:30:00 UTC` |
| `cal` | Displays a calendar. | `cal 11 2026` | Calendar for November 2026; see below. |
| `clear` | Clears the terminal display. | `clear` | Display clears and the prompt reappears; no ordinary text output. |
| `echo` | Prints a message. | `echo 'Hi!'` | `Hi!` |
| `history` | Lists commands in the current Bash history list. | `history 3` | Numbered command list; see below. |
| `touch` | Creates an empty file or updates an existing file's access and modification timestamps. | `touch practice.txt` | Normally no output. Verify with `ls -l practice.txt`. |
| `cat` | Displays a text file's contents. | `cat practice.txt` | Displays the file's text; see below. |

Load averages cover the last 1, 5, and 15 minutes; they are not CPU usage percentages. Group membership and timezone depend on the system. `cal` may require an additional package on minimal installations.

### Calendar example

Command:

```bash
cal 11 2026
```

Sample output (layout may vary):

```text
   November 2026
Su Mo Tu We Th Fr Sa
 1  2  3  4  5  6  7
 8  9 10 11 12 13 14
15 16 17 18 19 20 21
22 23 24 25 26 27 28
29 30
```

### History example

Command:

```bash
history 3
```

Sample output:

```text
    1  whoami
    2  hostname
    3  history 3
```

Numbers and entries vary. Avoid entering passwords or tokens directly in commands because they may be recorded.

### Create and read a practice file

Commands:

```bash
touch practice.txt
echo 'Welcome to Linux!' > practice.txt
cat practice.txt
```

Sample output from `cat`:

```text
Welcome to Linux!
```

`touch` preserves existing contents. The `>` operator replaces existing contents, so use a new or disposable file for this exercise.

## 4. Standard Input, Output, and Error

These are streams used by programs, rather than standalone commands.

| Stream | File descriptor | Short description | Default in an interactive terminal |
| --- | --- | --- | --- |
| Standard input (`stdin`) | `0` | Data a program reads. | Keyboard. |
| Standard output (`stdout`) | `1` | Normal results a program produces. | Terminal display. |
| Standard error (`stderr`) | `2` | Error messages and diagnostics. | Terminal display. |

### `stdin` — Read from the keyboard

Run:

```bash
cat
```

Type `Hello Linux` and press Enter. The terminal shows your input, then `cat` prints it back:

```text
Hello Linux
Hello Linux
```

The first line is your typed input; the second is output from `cat`. Press **Ctrl+D on an empty line** to end input.

### `stdout` — Print normal output

Command:

```bash
echo 'Task completed'
```

Sample output:

```text
Task completed
```

### `stderr` — Display an error

Command (assuming the file does not exist):

```bash
cat missing-file.txt
```

Sample error output:

```text
cat: missing-file.txt: No such file or directory
```

### Redirect streams and pipe output

> `>` and `2>` create or overwrite destination files. Use disposable filenames for practice. `>>` appends instead.

| Action | Sample command | Expected result |
| --- | --- | --- |
| Save stdout to a file. | `echo 'Hi!' > output.txt` | No terminal output; `output.txt` contains `Hi!`. |
| Append stdout to a file. | `echo 'Another line' >> output.txt` | Adds a line to `output.txt`. |
| Read stdin from a file. | `cat < output.txt` | Displays the contents of `output.txt`. |
| Save stderr to a file. | `cat missing-file.txt 2> errors.txt` | If the source file is missing, saves the error in `errors.txt`. |
| Send stdout to another command. | `echo 'hello linux' \| tr '[:lower:]' '[:upper:]'` | Displays `HELLO LINUX`. |

## 5. Validation and Troubleshooting

Run examples in a Bash terminal and compare the results. Check practice-file creation with `ls -l practice.txt` and contents with `cat practice.txt`.

| Symptom | What to check |
| --- | --- |
| `command not found` | Check spelling and installation. For example, `command -v cal` looks for `cal` in your command search path. |
| `Permission denied` | Check file permissions with `ls -l`, or directory permissions with `ls -ld .`. Use an authorized location; do not make sensitive files broadly readable. |
| `No such file or directory` | Check the filename, capitalization, and current directory with `pwd` and `ls`. |
| Bash configuration file is missing | Use `ls -a ~` to inspect available startup files. |
| Output differs | Compare username, hostname, timezone, locale, installed utilities, and distribution. |

**Validation status:** Documentation reviewed for consistency. Commands and outputs have not been tested on a live Linux system for this reference.
