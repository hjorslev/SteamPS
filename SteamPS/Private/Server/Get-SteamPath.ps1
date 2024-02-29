function Get-SteamPath {
    [CmdletBinding()]
    param (
    )

    process {
        $SteamCMDPath = $env:Path.Split([System.IO.Path]::PathSeparator) |
            Where-Object -FilterScript { $_ -like '*SteamCMD*' }

        if ($null -ne $SteamCMDPath) {
            [PSCustomObject]@{
                'Path'       = $SteamCMDPath
                'Executable' = "$SteamCMDPath\steamcmd.exe"
            }
        } else {
            Write-Verbose -Message 'SteamCMD where not found on the environment path.'
        }
    } # Process
} # Cmdlet