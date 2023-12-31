param (
    [string]$path,
    [switch]$remove
)

# Guard clause: Check if path is not provided
if (-not $path) {
    Write-Host "Please provide a valid path."
    return
}

$currentPath = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Machine)

$inPath = $currentPath -split ';' -contains $path

if ($remove) {
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

[System.Environment]::SetEnvironmentVariable('PATH', $newPath, [System.EnvironmentVariableTarget]::Machine)

Write-Host "Path $action successfully."

refreshenv
