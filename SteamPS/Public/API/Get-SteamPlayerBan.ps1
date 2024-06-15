function Get-SteamPlayerBan {
    <#
.SYNOPSIS
    Fetches ban information for Steam players.

    .DESCRIPTION
    This cmdlet fetches ban information about Steam players. The information includes whether the players are banned from the Steam Community, have VAC bans, the number of VAC bans, days since the last ban, number of game bans, and economy ban status.

    .PARAMETER SteamID64
    Specifies one or more 64-bit Steam IDs for which to fetch ban information. Enter the Steam IDs as a comma-separated list.

    .EXAMPLE
    Get-SteamPlayerBan -SteamID64 76561197960435530,76561197960434622

    This example fetches ban information for the players with the specified Steam IDs.

    .INPUTS
    int64[]: Specifies an array of 64-bit integers representing Steam IDs.

    .OUTPUTS
    Returns a PSCustomObject with the following properties:

    - SteamID64: The player's 64-bit ID.
    - CommunityBanned: A boolean indicating whether the player is banned from the Steam Community.
    - VACBanned: A boolean indicating whether the player has VAC bans on record.
    - NumberOfVACBans: The number of VAC bans on record.
    - DaysSinceLastBan: The number of days since the last ban.
    - NumberOfGameBans: The number of bans in games, including CS:GO Overwatch bans.
    - EconomyBan: The player's ban status in the economy. If the player has no bans on record, the string will be "none". If the player is on probation, it will say "probation", etc.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamPlayerBan.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = '64 bit Steam ID to return player bans for.',
            ValueFromPipelineByPropertyName = $true)]
        [int64[]]$SteamID64
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-RestMethod -Uri 'https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/' -UseBasicParsing -Body @{
            key      = Get-SteamAPIKey
            steamids = ($SteamID64 -join ',')
        }

        if (-not [string]::IsNullOrEmpty($Request.players.SteamId)) {
            foreach ($Item in $Request.players) {
                [PSCustomObject]@{
                    SteamID64        = [int64]$Item.SteamId
                    CommunityBanned  = $Item.CommunityBanned
                    VACBanned        = $Item.VACBanned
                    NumberOfVACBans  = $Item.NumberOfVACBans
                    DaysSinceLastBan = $Item.DaysSinceLastBan
                    NumberOfGameBans = $Item.NumberOfGameBans
                    EconomyBan       = $Item.EconomyBan
                }
            }
        } elseif ([string]::IsNullOrEmpty($Request.players)) {
            $Exception = [Exception]::new("SteamID $SteamID64 couldn't be found.")
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                'PlayerNotFound',
                [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                $Request
            )
            $PSCmdlet.WriteError($ErrorRecord)
        }
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet