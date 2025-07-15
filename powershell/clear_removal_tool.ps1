# Remove-ClearApp.ps1
# Purpose: Fully remove Clear.exe from all user profiles and system traces

Write-Output "Starting full removal of Clear.exe..."

# Stop any running instance of Clear.exe
Get-Process -Name "Clear" -ErrorAction SilentlyContinue | Stop-Process -Force

# Remove from all user AppData folders
$usersPath = "C:\Users"
$relativePath = "AppData\Local\Programs\clear"

Get-ChildItem -Path $usersPath -Directory | ForEach-Object {
    $userClearPath = Join-Path $_.FullName $relativePath
    if (Test-Path $userClearPath) {
        Write-Output "Removing: $userClearPath"
        Remove-Item -Path $userClearPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Also check the default user profile
$defaultUserPath = "C:\Users\Default\AppData\Local\Programs\clear"
if (Test-Path $defaultUserPath) {
    Write-Output "Removing default profile Clear.exe folder..."
    Remove-Item -Path $defaultUserPath -Recurse -Force -ErrorAction SilentlyContinue
}

# Remove Clear from Program Files and ProgramData (if it exists)
$additionalPaths = @(
    "$env:ProgramFiles\Clear",
    "$env:ProgramFiles(x86)\Clear",
    "$env:ProgramData\Clear"
)

foreach ($path in $additionalPaths) {
    if (Test-Path $path) {
        Write-Output "Removing: $path"
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Remove registry keys related to Clear.exe
$registryPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
)

foreach ($regPath in $registryPaths) {
    Get-ChildItem -Path $regPath -ErrorAction SilentlyContinue | ForEach-Object {
        $key = $_
        $name = (Get-ItemProperty -Path $key.PSPath -ErrorAction SilentlyContinue).DisplayName
        if ($name -like "*Clear*") {
            Write-Output "Removing registry key: $($key.PSChildName)"
            Remove-Item -Path $key.PSPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# Remove scheduled tasks related to Clear (if any)
$tasks = schtasks /query /fo LIST /v | Select-String "TaskName"
foreach ($task in $tasks) {
    if ($task.ToString() -like "*Clear*") {
        $taskName = $task.ToString().Split(":")[1].Trim()
        Write-Output "Deleting scheduled task: $taskName"
        schtasks /delete /tn "$taskName" /f | Out-Null
    }
}

# Clear TEMP folders
Get-ChildItem -Path "$env:Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Write-Output "Clear.exe removal completed."
