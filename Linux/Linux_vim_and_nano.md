# Editing Files with Vim and Nano

Use `vim` or `nano` to edit a text file directly from the Linux terminal. Run the examples in a directory where you can write files. If `notes.txt` does not exist, the editor opens an empty buffer and creates the file when you save it.

## 1. Vim

```bash
vim notes.txt
```

Vim starts in Normal mode, where keys run commands. Press `i` to enter Insert mode and type text. Press `Esc` to return to Normal mode. For commands starting with `:`, type the command and press `Enter`.

| Key or command | Action |
| --- | --- |
| `i` | Insert text before the cursor. |
| `Esc` | Return to Normal mode. |
| `h`, `j`, `k`, `l` | Move left, down, up, and right in Normal mode. Arrow keys also work. |
| `gg` / `G` | Go to the first or last line. |
| `x` | Delete the character under the cursor. |
| `dd` / `yy` / `p` | Cut the current line, copy the current line, or paste a cut or copied line below the current line. |
| `u` / `Ctrl+r` | Undo or redo the last change. |
| `/text` then `Enter` | Search forward for `text`. Press `n` for the next match or `N` for the previous match. |
| `:w` | Save and keep editing. |
| `:q` | Quit when there are no unsaved changes. |
| `:wq` | Save and quit. |
| `:q!` | Quit and discard unsaved changes. |

To practice, press `i`, type `Hello from Vim`, press `Esc`, type `:wq`, and press `Enter`.

## 2. Nano

```bash
nano notes.txt
```

Type to edit as soon as Nano opens. Use the arrow keys to move around. The shortcuts at the bottom of the screen use `^` for `Ctrl` and `M-` for `Alt`. For example, `^O` means hold `Ctrl` and press the letter `O`.

| Shortcut | Action |
| --- | --- |
| `Ctrl+O` | Save. Press `Enter` to confirm the filename. |
| `Ctrl+X` | Exit. If prompted about unsaved changes, press `Y` to save or `N` to discard. If you press `Y`, press `Enter` to confirm the filename. |
| `Ctrl+W` | Search. Type the search text and press `Enter`. |
| `Ctrl+K` | Cut the current line or selected text. |
| `Alt+6` | Copy the current line or selected text. |
| `Ctrl+U` | Paste text you cut or copied in Nano. |
| `Alt+U` / `Alt+E` | Undo or redo the last change. |
| `Ctrl+G` | Open Nano's help screen. |

To practice, add `Hello from Nano` on a new line, press `Ctrl+O` then `Enter` to save, and press `Ctrl+X` to exit. Run `cat notes.txt` to see what you saved.
