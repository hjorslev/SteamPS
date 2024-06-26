---
external help file: SteamPS-help.xml
Module Name: SteamPS
online version: https://hjorslev.github.io/SteamPS/Get-SteamPlayerBan.html
schema: 2.0.0
---

# Get-SteamPlayerBan

## SYNOPSIS
Returns Community, VAC, and Economy ban statuses for given players.

## SYNTAX

```
Get-SteamPlayerBan [-SteamID64] <Int64[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns Community, VAC, and Economy ban statuses for given players.

## EXAMPLES

### EXAMPLE 1
```
Get-SteamPlayerBan -SteamID64 76561197960435530, 76561197960434622
```

## PARAMETERS

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### int64[]: Specifies an array of 64-bit integers representing Steam IDs.
## OUTPUTS

### Returns a PSCustomObject with the following properties:
### - SteamID64: The player's 64-bit ID.
### - CommunityBanned: A boolean indicating whether the player is banned from the Steam Community.
### - VACBanned: A boolean indicating whether the player has VAC bans on record.
### - NumberOfVACBans: The number of VAC bans on record.
### - DaysSinceLastBan: The number of days since the last ban.
### - NumberOfGameBans: The number of bans in games, including CS:GO Overwatch bans.
### - EconomyBan: The player's ban status in the economy. If the player has no bans on record, the string will be "none". If the player is on probation, it will say "probation", etc.
## NOTES
Author: Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Get-SteamPlayerBan.html](https://hjorslev.github.io/SteamPS/Get-SteamPlayerBan.html)

