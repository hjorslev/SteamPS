function Get-SteamPlayerBan {
    <#
    .SYNOPSIS
    Retrieves ban information for Steam players.

    .DESCRIPTION
    This cmdlet retrieves ban information for Steam players, including whether they are banned from the Steam Community, have VAC bans, the number of VAC bans, days since the last ban, number of game bans, and economy ban status.

    .PARAMETER SteamID64
    Specifies one or more 64-bit Steam IDs for which to retrieve ban information. Enter the Steam IDs as a comma-delimited list.

    .EXAMPLE
    Get-SteamPlayerBan -SteamID64 76561197960435530,76561197960434622

    .INPUTS
    int64[]: Specifies an array of 64-bit integers representing Steam IDs.

    .OUTPUTS
    Returns objects with the following properties:

    - SteamID64: The player's 64 bit ID.
    - CommunityBanned: Indicates whether or not the player is banned from Steam Community.
    - VACBanned: Indicates whether or not the player has VAC bans on record.
    - NumberOfVACBans: Number of VAC bans on record.
    - DaysSinceLastBan: Number of days since the last ban.
    - NumberOfGameBans: Number of bans in games, this includes CS:GO Overwatch bans.
    - EconomyBan: The player's ban status in the economy. If the player has no bans on record the string will be "none", if the player is on probation it will say "probation", etc.

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

        if ($Request.players) {
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
        } elseif ($Request.players.Length -eq 0) {
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