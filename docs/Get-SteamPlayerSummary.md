---
external help file: SteamPS-help.xml
Module Name: steamps
online version: https://hjorslev.github.io/SteamPS/Get-SteamPlayerSummary.html
schema: 2.0.0
---

# Get-SteamPlayerSummary

## SYNOPSIS
Returns basic profile information for a list of 64-bit Steam IDs.

## SYNTAX

```
Get-SteamPlayerSummary [-SteamID64] <Int64[]> [[-OutputFormat] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns basic profile information for a list of 64-bit Steam IDs.

## EXAMPLES

### EXAMPLE 1
```
Get-SteamPlayerSummary -SteamID64 76561197960435530, 76561197960434622
```

## PARAMETERS

### -SteamID64
Comma-delimited list of 64 bit Steam IDs to return profile information for.
Up to 100 Steam IDs can be requested.

```yaml
Type: Int64[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OutputFormat
Format of the output.
Options are json (default), xml or vdf.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Json
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Array of int64.
## OUTPUTS

### Returns a string that is either formatted as json, xml or vdf.
### Some data associated with a Steam account may be hidden if the user has their
### profile visibility set to "Friends Only" or "Private". In that case, only
### public data will be returned.
### Public Data
### - steamid: 64bit SteamID of the user
### - personaname: The player's persona name (display name)
### - profileurl: The full URL of the player's Steam Community profile.
### - avatar: The full URL of the player's 32x32px avatar. If the user hasn't configured an avatar, this will be the default ? avatar.
### - avatarmedium: The full URL of the player's 64x64px avatar. If the user hasn't configured an avatar, this will be the default ? avatar.
### - avatarfull: The full URL of the player's 184x184px avatar. If the user hasn't configured an avatar, this will be the default ? avatar.
### - personastate: The user's current status. 0 - Offline, 1 - Online, 2 - Busy, 3 - Away, 4 - Snooze, 5 - looking to trade, 6 - looking to play. If the player's profile is private, this will always be "0", except if the user has set their status to looking to trade or looking to play, because a bug makes those status appear even if the profile is private.
### - communityvisibilitystate: This represents whether the profile is visible or not, and if it is visible, why you are allowed to see it. Note that because this WebAPI does not use authentication, there are only two possible values returned: 1 - the profile is not visible to you (Private, Friends Only, etc), 3 - the profile is "Public", and the data is visible. Mike Blaszczak's post on Steam forums says, "The community visibility state this API returns is different than the privacy state. It's the effective visibility state from the account making the request to the account being viewed given the requesting account's relationship to the viewed account."
### - profilestate: If set, indicates the user has a community profile configured (will be set to '1')
### - lastlogoff: The last time the user was online, in unix time. Only available when you are friends with the requested user (since Feb, 4).
### - commentpermission: If set, indicates the profile allows public comments.
### Private Data
### - realname: The player's "Real Name", if they have set it.
### - primaryclanid: The player's primary group, as configured in their Steam Community profile.
### - timecreated: The time the player's account was created.
### - gameid: If the user is currently in-game, this value will be returned and set to the gameid of that game.
### - gameserverip: The ip and port of the game server the user is currently playing on, if they are playing on-line in a game using Steam matchmaking. Otherwise will be set to "0.0.0.0:0".
### - gameextrainfo: If the user is currently in-game, this will be the name of the game they are playing. This may be the name of a non-Steam game shortcut.
### - cityid: This value will be removed in a future update (see loccityid)
### - loccountrycode: If set on the user's Steam Community profile, The user's country of residence, 2-character ISO country code
### - locstatecode: If set on the user's Steam Community profile, The user's state of residence
### - loccityid: An internal code indicating the user's city of residence. A future update will provide this data in a more useful way. steam_location gem/package makes player location data readable for output.
## NOTES
Author: Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Get-SteamPlayerSummary.html](https://hjorslev.github.io/SteamPS/Get-SteamPlayerSummary.html)

