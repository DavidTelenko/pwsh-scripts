param (
    [string]$Path
) 

if (-not $Path) {
    $Path = Get-Location
}

switch((ls $Path -r | measure -sum Length).Sum) {
    {$_ -gt 1GB} {
        '{0:0.0} GiB' -f ($_/1GB)
        break
    }
    {$_ -gt 1MB} {
        '{0:0.0} MiB' -f ($_/1MB)
        break
    }
    {$_ -gt 1KB} {
        '{0:0.0} KiB' -f ($_/1KB)
        break
    }
    default { "$_ bytes" }
}
