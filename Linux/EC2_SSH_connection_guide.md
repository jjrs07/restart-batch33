# EC2 SSH Connection Guide

Set permissions on your EC2 private key before connecting from your computer. SSH can reject a key that other users can read. This guide covers key permissions, OpenSSH connections, and PuTTY setup on Windows. Keep the original PEM contents intact.

## Before You Start

- Use the private key (`.pem`) matching the key pair assigned to your instance.
- Run these steps on the computer where the key is stored, before connecting to EC2.
- Replace `my-key.pem` and `INSTANCE_PUBLIC_DNS` with your actual filename and instance address.
- Keep private keys outside this repository. Do not upload them to GitHub, share them, or include their contents in screenshots.
- Have an SSH client installed. On Windows, choose OpenSSH in PowerShell or install the [PuTTY suite, including PuTTYgen](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

## Renaming a Downloaded PEM File

After downloading your private key, you can rename it, including removing the `.pem` extension. The filename and extension do not change the key contents, so OpenSSH can still use it to connect to EC2. Keep the required file permissions and use the new filename in permission commands and `ssh -i`.

Reasons to rename a key include:

- **Identify its purpose:** Rename a generic download such as `labsuser.pem` to `batch33-linux-lab.pem` so you can recognize the lab it belongs to.
- **Distinguish environments:** Use names such as `training-dev.pem` and `training-test.pem` to reduce confusion when working with multiple keys.
- **Simplify commands:** Replace spaces or long download names with a short name such as `batch33-key`. Removing the extension is optional; keeping `.pem` can make the file type easier to recognize.

Renaming only changes the local filename. It does not change the key pair assigned to EC2 or allow the key to connect to additional instances. Removing the extension also does not provide extra security; file permissions and keeping the key private provide protection.

For example, if you rename `my-key.pem` to `my-key`, connect with:

```bash
ssh -i "my-key" ec2-user@INSTANCE_PUBLIC_DNS
```

On Windows, enable **File name extensions** in File Explorer to see and remove the actual extension. For PuTTY, import the renamed key with PuTTYgen using the **All Files** filter, then save it in PPK format as described below.

## macOS and Linux

1. Open Terminal and go to the folder containing your key. For example:

   ```bash
   cd ~/Downloads
   ```

2. Allow only the file owner to read the key:

   ```bash
   chmod 400 "my-key.pem"
   ```

   `400` gives the owner read permission and gives the group and other users no access. Run this as the account that owns the key.

3. Verify the permissions:

   ```bash
   ls -l "my-key.pem"
   ```

   The permissions should start with `-r--------`. Some systems show an additional ACL or metadata marker after the mode; check any extra ACL entries if SSH still reports excessive access.

4. Connect to an Amazon Linux instance:

   ```bash
   ssh -i "my-key.pem" ec2-user@INSTANCE_PUBLIC_DNS
   ```

   For Ubuntu, use `ubuntu` instead of `ec2-user`. Verify the server host key fingerprint through a trusted source before accepting the first connection.

## Windows

Windows uses file access control lists instead of `chmod`. Use a local NTFS location owned by your Windows account, such as a folder under your user profile.

### Prepare the Key Automatically with PowerShell

[Prepare-EC2Key.ps1](Prepare-EC2Key.ps1) is a Windows helper script you run **after downloading your EC2 private key**. It looks for `labsuser.pem` in your account's Downloads folder, checks that your account owns it, and asks whether to rename it. Answer `yes`/`y` to supply a new filename or `no`/`n` to keep the current name. A new name may include `.pem` or omit the extension.

The script grants **Read and Write access to your account only**, removes inherited permissions, verifies the resulting permissions, and prints an SSH command example. It stops on missing files, invalid answers, conflicting filenames, and permission errors. It does not download the PEM key, convert it to PPK, or connect to EC2 for you. The manual methods below grant Read access only; the helper also grants owner Write access.

#### Download the Script

1. Open [Prepare-EC2Key.ps1](Prepare-EC2Key.ps1) in this repository on GitHub.
2. Use **Download raw file** to save it to your Windows **Downloads** folder. Keep the filename `Prepare-EC2Key.ps1`; make sure it is not saved with an extra `.txt` extension.
3. Open the downloaded script in a text editor and review it before running it.

If you already cloned the repository, you can copy `Linux/Prepare-EC2Key.ps1` to Downloads instead. The GitHub download becomes available after the script is committed and pushed to the repository.

#### Run the Script

1. Download your assigned `labsuser.pem` key into Downloads. Keep it outside the cloned repository.
2. If the key has a different filename, edit the script's `$keyPath` assignment to use that filename. If Downloads is redirected, update `$downloadsPath` too.
3. Open PowerShell as the Windows account that owns the key and run:

   ```powershell
   Set-Location (Join-Path $HOME "Downloads")
   .\Prepare-EC2Key.ps1
   ```

4. Answer the rename question. If you choose `yes`, enter a filename such as `batch33-key.pem` or `batch33-key`, without a folder path. If you choose `no`, the script still applies the permission changes.
5. Confirm the script reports **Key prepared successfully** and shows the final key path. Replace `INSTANCE_PUBLIC_DNS` in its printed SSH example with your instance address. Use `ubuntu` instead of `ec2-user` for Ubuntu instances.

If Windows marks the downloaded script as blocked, review it first, then right-click it, select **Properties**, check **Unblock** if shown, and select **Apply**. If PowerShell still reports that script execution is disabled, check `Get-ExecutionPolicy -List` and follow your instructor's or administrator's approved execution policy.

**Rerunning after a rename:** The script still starts by looking for `labsuser.pem`. Update its `$keyPath` assignment to the current filename before running it again. A rename is not rolled back if a later permission step fails; use the final filename shown in the output when troubleshooting.

### Set Key Permissions with File Explorer

1. Right-click the `.pem` file and select **Properties → Security → Advanced**.
2. Check that **Owner** is your Windows account. If needed, select **Change**, choose your account, and apply the change.
3. Select **Disable inheritance**, then **Remove all inherited permissions from this object**. If inheritance is already disabled, continue to the next step.
4. Select **Add → Select a principal**, enter your Windows account, and select **Check Names → OK**.
5. Grant your account **Read** permission and select **OK**. Remove any remaining explicit permission entries that grant other users access to this key.
6. Select **Apply**, then **OK** to save and close the dialogs. Reopen **Advanced Security Settings** to confirm that your account has Read access and other users have no access.

### Set Key Permissions and Connect with PowerShell

Run as the Windows account that owns the key. Update the path first, then run each command in order and stop if a command reports an error:

```powershell
$keyPath = "$env:USERPROFILE\Downloads\my-key.pem"
$account = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
icacls.exe $keyPath /reset
icacls.exe $keyPath /grant:r "${account}:(R)"
icacls.exe $keyPath /inheritance:r
icacls.exe $keyPath
```

The reset removes existing explicit permissions; the following commands grant your account Read access and remove inherited entries. In the final output, confirm that your account has `(R)` and no other account has access. If the owner is incorrect or access is denied, use the File Explorer steps to correct ownership first.

Connect from PowerShell:

```powershell
ssh -i $keyPath ec2-user@INSTANCE_PUBLIC_DNS
```

For Ubuntu, use `ubuntu` instead of `ec2-user`. Verify the server host key fingerprint before accepting the first connection.

### Connect with PuTTY (Alternative to OpenSSH)

PuTTY uses a `.ppk` private key. If you already have the matching PPK key, skip conversion.

1. Open **PuTTYgen**, select **Load**, and switch the file filter to **All Files** to find your PEM key.
2. Import `my-key.pem`; confirm the successful import. Use **Load**, not **Generate**, to preserve the existing key pair.
3. Optionally enter a key passphrase for additional protection. Select **Save private key** and save as `my-key.ppk`. If saving without a passphrase, PuTTYgen asks you to confirm.
4. Restrict access to the saved PPK file using the File Explorer permission steps above. Protect both key files and keep them outside the repository.
5. Open **PuTTY**. Under **Session**, enter `ec2-user@INSTANCE_PUBLIC_DNS` in **Host Name (or IP address)**, set **Port** to `22`, and select **SSH**. For Ubuntu, use `ubuntu` as the username.
6. Go to **Connection → SSH → Auth → Credentials**. Under **Private key file for authentication**, browse to `my-key.ppk`. Older versions may show this field directly under **Auth**.
7. Optionally return to **Session**, enter a name under **Saved Sessions**, and select **Save**.
8. Select **Open**. Compare the server host key fingerprint with a trusted value before accepting it. Enter your key passphrase if prompted.

Ensure the instance is running and its security group allows inbound TCP port 22 from your IP address. See the [AWS PuTTY walkthrough](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-linux-inst-from-windows.html) for details.

### Using WSL

If you run `ssh` inside WSL, copy the key into your WSL Linux home directory (for example, `~/.ssh/`) and follow the Linux permission steps on that copy. Permissions on Windows-mounted paths such as `/mnt/c/` may behave differently. Keep both copies private.

## Troubleshooting

| Symptom | What to check |
| --- | --- |
| `UNPROTECTED PRIVATE KEY FILE` or permissions are too open | Recheck the mode on macOS/Linux or the owner and permission entries on Windows. |
| `Permission denied (publickey)` | Confirm the AMI username, matching private key, and key path. Permission changes alone cannot fix a mismatched key. |
| PuTTY refuses the key | Confirm you loaded the matching `.ppk` file under Auth → Credentials and used the correct AMI username. |
| Key file not found | Check the current folder, filename, and quoted path. |
| Connection timed out | Check instance status, network reachability, and inbound TCP port 22 from your IP address. |
| `ssh` is not recognized on Windows | Install or enable the Windows OpenSSH Client optional feature, then reopen PowerShell. |

**Checkpoint:** Confirm restrictive key permissions and attempt SSH to your assigned instance. This documentation has been reviewed against AWS guidance; the Windows steps have not been executed on a Windows host here.

## References

- [AWS: Locate the private key and set permissions](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connection-prereqs-general.html)
- [AWS: Troubleshoot an unprotected private key file](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/TroubleshootingInstancesConnecting.html#troubleshoot-unprotected-key)
- [AWS: Connect using PuTTY](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-linux-inst-from-windows.html)
