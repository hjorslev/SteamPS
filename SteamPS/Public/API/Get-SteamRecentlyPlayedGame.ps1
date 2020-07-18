function Get-SteamRecentlyPlayedGame {
    <#
    .SYNOPSIS
    Returns a list of games a player has played in the last two weeks.

    .DESCRIPTION
    Returns a list of games a player has played in the last two weeks,
    if the profile is publicly visible. Private, friends-only, and other
    privacy settings are not supported unless you are asking for your own
    personal details (ie the WebAPI key you are using is linked to the steamid
    you are requesting).

    .PARAMETER SteamID
    64 bit Steam ID to return recently played games for.

    .PARAMETER Count
    Limit to a certain number of games (the number of games a person has played in the last 2 weeks is typically very small).

    .PARAMETER OutputFormat
    Format of the output. Options are json (default), xml or vdf.

    .EXAMPLE
    Get-SteamRecentlyPlayedGame -SteamID 76561197960434622

    .INPUTS
    Int64

    .OUTPUTS
    Returns a string that is either formatted as json, xml or vdf.

    total_count the total number of unique games the user has played in the last two weeks. This is mostly significant if you opted to return a limited number of games with the count input parameter

    A games array, with the following contents:
    - appid Unique identifier for the game
    - name The name of the game
    - playtime_2weeks The total number of minutes played in the last 2 weeks
    - playtime_forever The total number of minutes played "on record", since Steam began tracking total playtime in early 2009.
    - img_icon_url, img_logo_url - these are the filenames of various images for the game. To construct the URL to the image, use this format: http://media.steampowered.com/steamcommunity/public/images/apps/{appid}/{hash}.jpg. For example, the TF2 logo is returned as "07385eb55b5ba974aebbe74d3c99626bda7920b8", which maps to the URL: [2]

    .NOTES
    Author: Frederik Hjorslev Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamRecentlyPlayedGame.html
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = '64 bit Steam ID to return recently played games for.')]
        [int64]$SteamID,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Limit to a certain number of games (the number of games a person has played in the last 2 weeks is typically very small).')]
        [int]$Count = 0,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Format of the output. Options are json (default), xml or vdf.')]
        [ValidateSet('json', 'xml', 'vdf')]
        [string]$OutputFormat = 'json'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-WebRequest -Uri "https://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?format=$OutputFormat&key=$(Get-SteamAPIKey)&steamid=$SteamID&count=$Count"

        Write-Output -InputObject $Request.Content
    }

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
}