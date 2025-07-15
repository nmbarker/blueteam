# Silent PowerShell script to remove clear.exe and its containing directories from all user profiles

$usersPath = "C:\Users"
$targetRelativeDir = "AppData\Local\Programs\clear"

Get-ChildItem -Path $usersPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $userProfile = $_.FullName
    $targetDir = Join-Path $userProfile $targetRelativeDir

    if (Test-Path $targetDir) {
        # Force delete the entire 'clear' directory quietly
        Remove-Item -Path $targetDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
