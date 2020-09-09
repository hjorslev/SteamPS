﻿function Get-SteamFriendList {
    <#
    .SYNOPSIS
    Returns the friend list of any Steam user.

    .DESCRIPTION
    Returns the friend list of any Steam user, provided their Steam Community
    profile visibility is set to "Public".

    .PARAMETER SteamID64
    64 bit Steam ID to return friend list for.

    .PARAMETER Relationship
    Relationship filter. Possibles values: all, friend.

    .PARAMETER OutputFormat
    Format of the output. Options are json (default), xml or vdf.

    .EXAMPLE
    Get-SteamFriendList -SteamID64 76561197960435530

    Outputs the user's friends list, as an array of friends.

    .EXAMPLE
    Get-SteamFriendList -SteamID64 76561197960435530 | ConvertFrom-Json

    Outputs the user's friends list, as an array of friends and converts it from
    Json to PSCustomObjects.

    .INPUTS
    int64

    .OUTPUTS
    Returns a string that is either formatted as json, xml or vdf.

    The user's friends list, as an array of friends. Nothing will be returned
    if the profile is private.

    In the array, the following three properties are returned:
    - steamid: 64 bit Steam ID of the friend.
    - relationship: Relationship qualifier.
    - friend_since: Unix timestamp of the time when the relationship was created.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamFriendList.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = '64 bit Steam ID to return friend list for.',
            ValueFromPipelineByPropertyName = $true)]
        [int64]$SteamID64,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Relationship filter. Possibles values: all, friend.')]
        [ValidateSet('all', 'friend')]
        [string]$Relationship,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Format of the output. Options are json (default), xml or vdf.')]
        [ValidateSet('json', 'xml', 'vdf')]
        [string]$OutputFormat = 'json'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamUser/GetFriendList/v1/?key=$(Get-SteamAPIKey)&steamid=$SteamID64&relationship=friend&format=$OutputFormat" -UseBasicParsing

        Write-Output -InputObject $Request.Content
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet