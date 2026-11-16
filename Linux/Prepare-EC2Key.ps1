# Run this script on Windows after downloading labsuser.pem.
$ErrorActionPreference = "Stop"

try {
    if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) {
        throw "This script requires Windows."
    }

    # Change this path if your Downloads folder is redirected.
    $downloadsPath = Join-Path $HOME "Downloads"
    $keyPath = Join-Path $downloadsPath "labsuser.pem"

    if (-not (Test-Path -LiteralPath $keyPath -PathType Leaf)) {
        throw "PEM file not found: $keyPath"
    }

    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $account = $identity.Name
    $owner = (Get-Acl -LiteralPath $keyPath).GetOwner(
        [System.Security.Principal.SecurityIdentifier]
    )
    if ($owner.Value -ne $identity.User.Value) {
        throw "Your Windows account must own the key. Correct ownership in Properties > Security > Advanced first."
    }

    $answer = (Read-Host -Prompt "Do you want to rename labsuser.pem? (yes/no)").Trim()

    if ($answer -eq "yes" -or $answer -eq "y") {
        $newKeyName = (Read-Host -Prompt "Enter the new filename (include .pem if wanted; leaving it out is allowed)").Trim()

        if ([string]::IsNullOrWhiteSpace($newKeyName) -or
            $newKeyName.IndexOfAny([IO.Path]::GetInvalidFileNameChars()) -ge 0 -or
            $newKeyName.EndsWith(".") -or
            $newKeyName -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\.|$)') {
            throw "Enter a valid Windows filename, without a folder path."
        }

        $newKeyPath = Join-Path $downloadsPath $newKeyName
        if ($newKeyPath -ne $keyPath) {
            if (Test-Path -LiteralPath $newKeyPath) {
                throw "A file or folder already exists with that name: $newKeyPath"
            }
            Rename-Item -LiteralPath $keyPath -NewName $newKeyName -ErrorAction Stop
            $keyPath = $newKeyPath
            Write-Host "PEM file renamed to $newKeyName."
        }
    } elseif ($answer -eq "no" -or $answer -eq "n") {
        Write-Host "Keeping the current filename."
    } else {
        throw "Invalid response. Please run the script again and answer yes or no."
    }

    # Reset explicit permissions, grant this account Read and Write, then remove inheritance.
    # Check native command exit codes because failures do not reliably throw.
    & icacls.exe $keyPath /reset
    if ($LASTEXITCODE -ne 0) { throw "Could not reset key permissions." }

    & icacls.exe $keyPath /grant:r "${account}:(R,W)"
    if ($LASTEXITCODE -ne 0) { throw "Could not grant Read and Write permissions." }

    & icacls.exe $keyPath /inheritance:r
    if ($LASTEXITCODE -ne 0) { throw "Could not remove inherited permissions." }

    $acl = Get-Acl -LiteralPath $keyPath
    $rules = @($acl.GetAccessRules($true, $true, [System.Security.Principal.SecurityIdentifier]))
    if (-not $acl.AreAccessRulesProtected -or $rules.Count -ne 1) {
        throw "Unexpected permissions remain. Inspect the key in Properties > Security > Advanced."
    }
    $rule = $rules[0]
    # Windows may add Synchronize to an Allow rule. Permit that flag while
    # requiring Read and Write and rejecting all other additional rights.
    $requiredRights = [System.Security.AccessControl.FileSystemRights]::Read -bor
        [System.Security.AccessControl.FileSystemRights]::Write
    $allowedRights = $requiredRights -bor
        [System.Security.AccessControl.FileSystemRights]::Synchronize
    $actualRights = $rule.FileSystemRights
    if ($rule.IdentityReference.Value -ne $identity.User.Value -or
        $rule.AccessControlType -ne [System.Security.AccessControl.AccessControlType]::Allow -or
        ($actualRights -band $requiredRights) -ne $requiredRights -or
        ($actualRights -band (-bnot $allowedRights)) -ne 0) {
        throw "Owner-only Read and Write access could not be verified. Inspect the key permissions."
    }

    Write-Host "Key prepared successfully: $keyPath"
    Write-Host ('SSH example: ssh -i "{0}" ec2-user@INSTANCE_PUBLIC_DNS' -f $keyPath)
    Write-Host "For Ubuntu instances, use ubuntu instead of ec2-user."
} catch {
    Write-Error "Key preparation stopped: $($_.Exception.Message)" -ErrorAction Continue
    exit 1
}
