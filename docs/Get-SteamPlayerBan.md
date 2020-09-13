---
external help file: SteamPS-help.xml
Module Name: steamps
online version: https://hjorslev.github.io/SteamPS/Get-SteamPlayerBan.html
schema: 2.0.0
---

# Get-SteamPlayerBan

## SYNOPSIS
Returns Community, VAC, and Economy ban statuses for given players.

## SYNTAX

```
Get-SteamPlayerBan [-SteamID64] <Int64[]> [[-OutputFormat] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns Community, VAC, and Economy ban statuses for given players.

## EXAMPLES

### EXAMPLE 1
```
Get-SteamPlayerBan -SteamID64 76561197960435530, 76561197960434622
```

## PARAMETERS

### -SteamID64
Comma-delimited list of 64 bit Steam IDs to return player ban information for.

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
### players: List of player ban objects for each 64 bit ID requested
### - SteamId (string) The player's 64 bit ID.
### - CommunityBanned (bool) Indicates whether or not the player is banned from Steam Community.
### - VACBanned (bool) Indicates whether or not the player has VAC bans on record.
### - NumberOfVACBans (int) Number of VAC bans on record.
### - DaysSinceLastBan (int) Number of days since the last ban.
### - NumberOfGameBans (int) Number of bans in games, this includes CS:GO Overwatch bans.
### - EconomyBan (string) The player's ban status in the economy. If the player has no bans on record the string will be "none", if the player is on probation it will say "probation", etc.
## NOTES
Author: Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Get-SteamPlayerBan.html](https://hjorslev.github.io/SteamPS/Get-SteamPlayerBan.html)

