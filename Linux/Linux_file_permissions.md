# Linux File Permissions

Linux uses three sets of permission bits for files and directories. They apply to the owner (`u`), the owning group (`g`), and others (`o`). Use `ls` to view permissions, `chmod` to change them, and `chgrp` to change the owning group.

## 1. View permissions with `ls`

Create a temporary directory for the examples.

```bash
practice_dir=$(mktemp -d)
cd "$practice_dir"
touch notes.txt
mkdir shared
chmod 640 notes.txt
ls -l notes.txt
ls -ld shared
```

`ls -l` shows details for a file. Use `ls -ld` to view a directory’s own permissions. For example, `ls -l notes.txt` might show this line.

```text
-rw-r----- 1 student labteam 0 Nov 19 09:00 notes.txt
```

Read `-rw-r-----` as `- | rw- | r-- | ---`.

| Field | Meaning |
| --- | --- |
| `-` | Regular file. A `d` in this position identifies a directory. |
| `rw-` | The owner, `student`, can read and write the file. |
| `r--` | The owning group, `labteam`, has read permission. |
| `---` | Others have no permissions. |

| Bit | On a file | On a directory |
| --- | --- | --- |
| `r` | Read the contents. | List entry names. |
| `w` | Modify the contents. | With `x`, create, delete, or rename entries. |
| `x` | Execute the file as a program. | Traverse the directory and access entries by name, subject to their own permissions. |

## 2. Change permissions with `chmod` in symbolic mode

Choose who to change (`u`, `g`, `o`, or `a` for all three), an operator (`+` to add, `-` to remove, or `=` to set exactly), and the permissions (`r`, `w`, `x`).

```bash
chmod g+w notes.txt      # Add group write, keeping group read
chmod g-w notes.txt      # Remove group write
chmod g=rw notes.txt     # Set group permissions to read and write
chmod u=rw,g=r,o= notes.txt  # Set owner to read/write, group to read, and others to none
ls -l notes.txt
```

## 3. Change permissions with `chmod` in absolute mode

Absolute mode uses three octal digits in owner, group, others order for basic permissions. For each digit, add `4` for read, `2` for write, and `1` for execute. Use `0` for no permissions.

| Command | Owner | Group | Others |
| --- | --- | --- | --- |
| `chmod 600 notes.txt` | `rw-` | `---` | `---` |
| `chmod 640 notes.txt` | `rw-` | `r--` | `---` |
| `chmod 664 notes.txt` | `rw-` | `rw-` | `r--` |
| `chmod 770 shared` | `rwx` | `rwx` | `---` |

For `640`, the owner’s `6` is `4 + 2`, the group’s `4` is read only, and the final `0` removes all permissions for others. After any change, check the result with `ls -l` or `ls -ld`.

## 4. View and change group permissions and ownership

Use the middle permission triplet in `ls -l` to check group permissions and the column after the owner’s name to identify the owning group. `id -Gn` lists the groups for your current session.

```bash
id -Gn
ls -l notes.txt
chmod g=rw notes.txt
ls -l notes.txt
```

To assign the file to a different group, replace `labteam` with an existing group you belong to. A regular user generally needs to own the file to change its group.

```bash
chgrp labteam notes.txt
ls -l notes.txt
```

`chmod g=rw` sets the group permission bits. `chgrp` changes which group those bits apply to. A user also needs execute permission on the parent directories to reach the file.
