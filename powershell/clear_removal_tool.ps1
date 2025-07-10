$usersPath = "C:\Users"
$targetRelativePath = "Appdata\Local\Programs\clear\1.1.1.0\clear.exe"

Get-ChildItem -Path $usersPath -Directory | ForEach-Object {
    $userProfile = $_.FullName
    $targetPath = Join-Path $userProfile $targetRelativePath

    if (Test-Path $targetPath) {
        try {
            Remove-Item -Path $targetPath -Force
            Write-Host "Removed: $targetPath"
        } catch {
            Write-Warning "Failed to remove"
        }
    } else {
        Write-Host "Clear not found"
    }
}