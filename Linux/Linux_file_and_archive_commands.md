# Linux File and Archive Commands

Run these examples in a writable practice directory. Start with two small text files for the examples.

```bash
printf 'Draft\nLinux notes\n' > lesson-notes.txt
printf 'Final\nLinux notes\n' > lesson-final.txt
```

## 1. `hash` — View Bash’s cached command paths

Bash remembers the paths of external programs it has located. Run `hash` to list those paths and their hit counts. Use `history` to see the command lines you entered.

```bash
ls
hash
hash -t ls    # Show the cached path for ls
hash -r       # Clear the command path cache
history 10    # Show the last 10 history entries
```

## 2. `cksum` — Check whether a file changed

`cksum` prints a CRC checksum, the file size in bytes, and the filename. Save the output as a baseline and compare it with a later run. A difference indicates that the file changed if you compare the same filename. CRC checksums are intended for detecting accidental changes.

```bash
cksum lesson-notes.txt > lesson-notes.cksum
cksum lesson-notes.txt | diff - lesson-notes.cksum
```

The second command prints nothing when the recorded values match. Here, `-` tells `diff` to read its first input from the pipe.

## 3. `find` — Search for files by name, size, or owner

`find` searches a directory and its subdirectories. Use `.` to start in the current directory and `-type f` to select regular files.

```bash
find . -type f -name '*.txt'   # Find files ending in .txt
find . -type f -size +1M      # Find files larger than 1 MiB
find . -type f -user "$USER"  # Find files owned by your user account
```

Quote `*.txt` so `find` receives the pattern and applies it throughout the search.

## 4. `grep` — Search file contents for a pattern

```bash
grep -n 'Linux' lesson-notes.txt     # Show matching lines with line numbers
grep -in 'linux' lesson-notes.txt    # Match regardless of case
grep -rn 'Linux' .                  # Search files under the current directory
```

Use `grep -F` when you want the search text treated literally, including characters such as `.` and `*`.

## 5. `diff` — Compare two files

```bash
diff -u lesson-notes.txt lesson-final.txt
```

In the unified output, `-` marks lines from the first file that were removed or replaced, and `+` marks lines added in the second file. Identical files produce no output.

## 6. `ln` — Create links to a file

```bash
ln lesson-notes.txt lesson-hard.txt       # Create a hard link
ln -s lesson-notes.txt lesson-symlink.txt  # Create a symbolic link
ls -li lesson-notes.txt lesson-hard.txt lesson-symlink.txt
```

A hard link is another name for the same file and shares its inode. A symbolic link stores a path to its target and can break if that target is moved or deleted.

## 7. `tar` — Bundle files into one archive

```bash
tar -cf lesson.tar lesson-notes.txt lesson-final.txt  # Create an archive
tar -tf lesson.tar                                   # List its contents
mkdir -p tar-output
tar -xf lesson.tar -C tar-output                     # Extract into tar-output
```

The `.tar` archive above is uncompressed. Add `-z` to use gzip compression, such as `tar -czf lesson.tar.gz lesson-notes.txt lesson-final.txt`.

## 8. `gzip` — Compress a single file

```bash
gzip -k lesson.tar       # Create lesson.tar.gz and keep lesson.tar
gzip -dc lesson.tar.gz > lesson-restored.tar
```

The second command decompresses the archive to standard output, which is redirected to `lesson-restored.tar`. Without `-k` or `-c`, `gzip` normally replaces its input with the output file.

## 9. `zip` — Compress files into a ZIP archive

```bash
zip lesson.zip lesson-notes.txt lesson-final.txt  # Archive two files
zip -r lesson-folder.zip tar-output              # Include a directory and its contents
```

## 10. `unzip` — List or extract a ZIP archive

```bash
unzip -l lesson.zip              # List the contents
unzip lesson.zip -d zip-output  # Extract into zip-output
```
