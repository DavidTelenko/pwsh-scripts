<#
.SYNOPSIS
    This script adds or Removes a Path from the PATH environment variable.

.DESCRIPTION
    This script allows you to add or Remove a specified Path from the PATH environment variable.
    It provides the flexibility to choose the action using the -r (Remove) switch.

.PARAMETER Path
    Specifies the path to be added or removed from the PATH variable.

.PARAMETER Remove
    If specified, the script will remove the specified path from the PATH variable.

.EXAMPLE
    .\enva.ps1 -Path "C:\Your\Path\Here"
    Adds the specified path to the PATH variable.

.EXAMPLE
    .\enva.ps1 -Path "C:\Path\To\Remove" -Remove
    Removes the specified path from the PATH variable.
#>

param (
    [string]$Path,
    [switch]$Remove
)

# Guard clause: Check if path is not provided
if (-not $Path) {
    Write-Host "Please provide a valid path."
    return
}

$Path = $Path -replace '/', '\'

$currentPath = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Machine)

$inPath = $currentPath -split ';' -contains $path

if ($Remove) {
    if (-not $inPath) {
        Write-Host "Path is not present in the PATH variable. No changes made."
        return
    }

    # Remove the specified path from the existing PATH variable
    $newPath = ($currentPath -split ';' | Where-Object { $_ -ne $path }) -join ';'
    $action = "removed"
} else {
    if ($inPath) {
        Write-Host "Path is already in the PATH variable. No changes made."
        return
    }

    # Add the new path to the existing PATH variable, ensuring no extra semicolons
    $newPath = $currentPath.TrimEnd(';') + ";" + $path
    $action = "added"
}

[System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::Machine)

Write-Host "Path '$Path' $action successfully."

refreshenv
