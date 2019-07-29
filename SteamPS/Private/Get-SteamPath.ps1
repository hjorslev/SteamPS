function Get-SteamPath {
    [CmdletBinding()]
    param (
    )

    process {
        $SteamCMDPath = $env:Path.Split(';') | Where-Object -FilterScript { $_ -like "*SteamCMD*" }
        if ($null -ne $SteamCMDPath) {
            $ObjectProperties = [ordered]@{
                'Path'       = $SteamCMDPath;
                'Executable' = "$($SteamCMDPath)\steamcmd.exe";
            }

            New-Object –TypeName PSObject –Property $ObjectProperties
        } # if
    } # Process
} # Cmdlet