function Get-SteamPlayerBan {
    <#
    .SYNOPSIS
    Returns Community, VAC, and Economy ban statuses for given players.

    .DESCRIPTION
    Returns Community, VAC, and Economy ban statuses for given players.

    .PARAMETER SteamID64
    Comma-delimited list of 64 bit Steam IDs to return player ban information for.

    .PARAMETER OutputFormat
    Format of the output. Options are json (default), xml or vdf.

    .EXAMPLE
    Get-SteamPlayerBan -SteamID64 76561197960435530, 76561197960434622

    .INPUTS
    Array of int64.

    .OUTPUTS
    Returns a string that is either formatted as json, xml or vdf.

    players: List of player ban objects for each 64 bit ID requested
    - SteamId (string) The player's 64 bit ID.
    - CommunityBanned (bool) Indicates whether or not the player is banned from Steam Community.
    - VACBanned (bool) Indicates whether or not the player has VAC bans on record.
    - NumberOfVACBans (int) Number of VAC bans on record.
    - DaysSinceLastBan (int) Number of days since the last ban.
    - NumberOfGameBans (int) Number of bans in games, this includes CS:GO Overwatch bans.
    - EconomyBan (string) The player's ban status in the economy. If the player has no bans on record the string will be "none", if the player is on probation it will say "probation", etc.

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
        [int64[]]$SteamID64,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Format of the output. Options are json (default), xml or vdf.')]
        [ValidateSet('json', 'xml', 'vdf')]
        [string]$OutputFormat = 'json'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?format=$OutputFormat&key=$(Get-SteamAPIKey)&steamids=$($SteamID64 -join ',')" -UseBasicParsing

        Write-Output -InputObject $Request.Content
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet