function Get-SteamPlayerSummary {
    <#
    .SYNOPSIS
    Returns basic profile information for a list of 64-bit Steam IDs.

    .DESCRIPTION
    Returns basic profile information for a list of 64-bit Steam IDs.

    .PARAMETER SteamID64
    Comma-delimited list of 64 bit Steam IDs to return profile information for.
    Up to 100 Steam IDs can be requested.

    .PARAMETER OutputFormat
    Format of the output. Options are json (default), xml or vdf.

    .EXAMPLE
    Get-SteamPlayerSummary -SteamID64 76561197960435530, 76561197960434622

    .INPUTS
    Array of int64.

    .OUTPUTS
    Returns a string that is either formatted as json, xml or vdf.

    Some data associated with a Steam account may be hidden if the user has their
    profile visibility set to "Friends Only" or "Private". In that case, only
    public data will be returned.

    Public Data
    - steamid: 64bit SteamID of the user
    - personaname: The player's persona name (display name)
    - profileurl: The full URL of the player's Steam Community profile.
    - avatar: The full URL of the player's 32x32px avatar. If the user hasn't configured an avatar, this will be the default ? avatar.
    - avatarmedium: The full URL of the player's 64x64px avatar. If the user hasn't configured an avatar, this will be the default ? avatar.
    - avatarfull: The full URL of the player's 184x184px avatar. If the user hasn't configured an avatar, this will be the default ? avatar.
    - personastate: The user's current status. 0 - Offline, 1 - Online, 2 - Busy, 3 - Away, 4 - Snooze, 5 - looking to trade, 6 - looking to play. If the player's profile is private, this will always be "0", except if the user has set their status to looking to trade or looking to play, because a bug makes those status appear even if the profile is private.
    - communityvisibilitystate: This represents whether the profile is visible or not, and if it is visible, why you are allowed to see it. Note that because this WebAPI does not use authentication, there are only two possible values returned: 1 - the profile is not visible to you (Private, Friends Only, etc), 3 - the profile is "Public", and the data is visible. Mike Blaszczak's post on Steam forums says, "The community visibility state this API returns is different than the privacy state. It's the effective visibility state from the account making the request to the account being viewed given the requesting account's relationship to the viewed account."
    - profilestate: If set, indicates the user has a community profile configured (will be set to '1')
    - lastlogoff: The last time the user was online, in unix time. Only available when you are friends with the requested user (since Feb, 4).
    - commentpermission: If set, indicates the profile allows public comments.

    Private Data
    - realname: The player's "Real Name", if they have set it.
    - primaryclanid: The player's primary group, as configured in their Steam Community profile.
    - timecreated: The time the player's account was created.
    - gameid: If the user is currently in-game, this value will be returned and set to the gameid of that game.
    - gameserverip: The ip and port of the game server the user is currently playing on, if they are playing on-line in a game using Steam matchmaking. Otherwise will be set to "0.0.0.0:0".
    - gameextrainfo: If the user is currently in-game, this will be the name of the game they are playing. This may be the name of a non-Steam game shortcut.
    - cityid: This value will be removed in a future update (see loccityid)
    - loccountrycode: If set on the user's Steam Community profile, The user's country of residence, 2-character ISO country code
    - locstatecode: If set on the user's Steam Community profile, The user's state of residence
    - loccityid: An internal code indicating the user's city of residence. A future update will provide this data in a more useful way. steam_location gem/package makes player location data readable for output.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamPlayerSummary.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = '64 bit Steam ID to return player summary for.',
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
        $Request = Invoke-RestMethod -Uri 'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2' -UseBasicParsing -Body @{
            key      = Get-SteamAPIKey
            steamids = ($SteamID64 -join ',')
        }

        if ($Request.response.players) {
            foreach ($Item in $Request.response.players) {
                [PSCustomObject]@{
                    SteamID64                = $Item.steamid
                    PersonaName              = $Item.personaname
                    ProfileUrl               = $Item.profileurl
                    Avatar                   = $Item.avatar
                    AvatarMedium             = $Item.avatarmedium
                    AvatarFull               = $Item.avatarfull
                    AvatarHash               = $Item.avatarhash
                    PersonaState             = [PersonaState]$Item.personastate
                    CommunityVisibilityState = [CommunityVisibilityState]$Item.communityvisibilitystate
                    ProfileState             = $Item.profilestate
                    LastLogOff               = ((Get-Date "01.01.1970") + ([System.TimeSpan]::FromSeconds($Item.lastlogoff))).ToString("yyyy-MM-dd HH:mm:ss")
                    CommentPermission        = $Item.commentpermission
                    RealName                 = $Item.realname
                    PrimaryClanID            = $Item.primaryclanid
                    TimeCreated              = ((Get-Date "01.01.1970") + ([System.TimeSpan]::FromSeconds($Item.timecreated))).ToString("yyyy-MM-dd HH:mm:ss")
                    AppID                   = $Item.gameid
                    GameServerIP             = [ipaddress]$Item.gameserverip
                    GameExtraInfo            = $Item.gameextrainfo
                    PersonaStateFlags        = $Item.personastateflags
                    LocCountryCode           = $Item.loccountrycode
                    LocStateCode             = $Item.locstatecode
                    LocCityID                = $Item.loccityid
                }
            }
        } elseif ($Request.response.players.Length -eq 0) {
            $Exception = [Exception]::new("SteamID $SteamID64 couldn't be found.")
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                'NoPlayerFound',
                [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                $Request
            )
            $PSCmdlet.WriteError($ErrorRecord)
        }
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
}