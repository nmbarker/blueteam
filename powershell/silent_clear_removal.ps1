# Silent cleanup of Clear.exe files, folders, and registry entries

# Remove Clear directory for all users
$usersPath = "C:\Users"
$targetRelativeDir = "AppData\Local\Programs\clear"

Get-ChildItem -Path $usersPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $userProfile = $_.FullName
    $targetDir = Join-Path $userProfile $targetRelativeDir

    if (Test-Path $targetDir) {
        Remove-Item -Path $targetDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Remove HKCU registry keys by loading user hives (if script is run as SYSTEM)
    $ntUserDat = Join-Path $userProfile "NTUSER.DAT"
    if (Test-Path $ntUserDat) {
        try {
            $tempHiveName = "TempHive_$($_.Name)"
            reg load "HKU\$tempHiveName" "$ntUserDat" > $null 2>&1

            Remove-Item -Path "Registry::HKU\$tempHiveName\Software\Clear" -Recurse -Force -ErrorAction SilentlyContinue

            reg unload "HKU\$tempHiveName" > $null 2>&1
        } catch {
            # fail silently
        }
    }
}

# Remove machine-wide registry keys (HKLM uninstall keys etc.)
$possibleHKLMPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Clear",
    "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Clear",
    "HKLM:\SOFTWARE\Clear"
)

foreach ($path in $possibleHKLMPaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}
