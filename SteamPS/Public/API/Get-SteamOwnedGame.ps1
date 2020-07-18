﻿function Get-SteamOwnedGame {
    <#
    .SYNOPSIS
    Returns a list of games a player owns along with some playtime information.

    .DESCRIPTION
    Returns a list of games a player owns along with some playtime information,
    if the profile is publicly visible. Private, friends-only, and other privacy
    settings are not supported unless you are asking for your own personal
    details (ie the WebAPI key you are using is linked to the steamid you are requesting).

    .PARAMETER SteamID
    64 bit Steam ID to return friend list for.

    .PARAMETER AppInfo
    Include game name and logo information in the output. The default is to return
    appids only.

    .PARAMETER FreeGames
    By default, free games like Team Fortress 2 are excluded (as technically
    everyone owns them). If -FreeGames is set, they will be returned if the
    player has played them at some point. This is the same behavior as the games
    list on the Steam Community.

    .PARAMETER OutputFormat
    Output format. json (default), xml or vdf.

    .EXAMPLE
    Get-SteamOwnedGame -SteamID 76561197960434622

    .INPUTS
    int64

    .OUTPUTS
    Returns a string that is either formatted as json, xml or vdf.

    game_count the total number of games the user owns (including free games
    they've played, if include_played_free_games was passed)

    A games array, with the following contents (note that if "include_appinfo"
    was not passed in the request, only appid, playtime_2weeks, and playtime_forever
    will be returned):
    - appid Unique identifier for the game
    - name The name of the game
    - playtime_2weeks The total number of minutes played in the last 2 weeks
    - playtime_forever The total number of minutes played "on record", since
    Steam began tracking total playtime in early 2009.
    - img_icon_url, img_logo_url - these are the filenames of various images
    for the game. To construct the URL to the image, use this format:
    http://media.steampowered.com/steamcommunity/public/images/apps/{appid}/{hash}.jpg.
    For example, the TF2 logo is returned as "07385eb55b5ba974aebbe74d3c99626bda7920b8",
    which maps to the URL: [1]
    - has_community_visible_stats indicates there is a stats page with achievements
    or other game stats available for this game. The uniform URL for accessing
    this data is http://steamcommunity.com/profiles/{steamid}/stats/{appid}.
    For example, Robin's TF2 stats can be found at:
    http://steamcommunity.com/profiles/76561197960435530/stats/440. You may
    notice that clicking this link will actually redirect to a vanity URL
    like /id/robinwalker/stats/TF2

    .NOTES
    Author: Frederik Hjorslev Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamOwnedGames.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = '64 bit Steam ID to return friend list for.')]
        [int64]$SteamID,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Include game name and logo information in the output. The default is to return appids only.')]
        [switch]$AppInfo,

        [Parameter(Mandatory = $false,
            HelpMessage = 'By default, free games like Team Fortress 2 are excluded (as technically everyone owns them). If -FreeGames is set, they will be returned if the player has played them at some point. This is the same behavior as the games list on the Steam Community.')]
        [switch]$FreeGames,

        <# TODO
        [Parameter(Mandatory = $false,
            HelpMessage = 'You can optionally filter the list to a set of appids.')]
        [int[]]$AppIDsFilter,#>

        [Parameter(Mandatory = $false,
            HelpMessage = 'Output format. json (default), xml or vdf.')]
        [ValidateSet('json', 'xml', 'vdf')]
        [string]$OutputFormat = 'json'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        if ($AppInfo) {
            $AppInfoQuery = 'include_appinfo=true'
        } else {
            $AppInfoQuery = 'include_appinfo=false'
        }
        if ($FreeGames) {
            $FreeGamesQuery = 'include_played_free_games=true'
        } else {
            $FreeGamesQuery = 'include_played_free_games=false'
        }
        if ($AppIDsFilter.Count -ge 0) {
            #$AppIDsFilterQuery = "input_json={`"appids_filter`": [ $($AppIDsFilter -join ',') ]}"
        }

        $Request = Invoke-WebRequest -Uri "https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?format=$OutputFormat&key=$(Get-SteamAPIKey)&steamid=$SteamID&$($AppInfoQuery, $FreeGamesQuery -join '&')"

        Write-Output -InputObject $Request.Content
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet