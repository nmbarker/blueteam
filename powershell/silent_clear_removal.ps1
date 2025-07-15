# Run silently - no output, no user interaction
$usersPath = "C:\Users"
$targetRelativePath = "AppData\Local\Programs\clear\1.1.1.0\clear.exe"

Get-ChildItem -Path $usersPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $userProfile = $_.FullName
    $targetPath = Join-Path $userProfile $targetRelativePath

    if (Test-Path $targetPath) {
        Remove-Item -Path $targetPath -Force -ErrorAction SilentlyContinue
    }
}
