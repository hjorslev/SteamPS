---
external help file: SteamPS-help.xml
Module Name: steamps
online version: https://hjorslev.github.io/SteamPS/Get-SteamFriendList.html
schema: 2.0.0
---

# Get-SteamFriendList

## SYNOPSIS
Returns the friend list of any Steam user.

## SYNTAX

```
Get-SteamFriendList [-SteamID64] <Int64> [[-Relationship] <String>] [[-OutputFormat] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns the friend list of any Steam user, provided their Steam Community
profile visibility is set to "Public".

## EXAMPLES

### EXAMPLE 1
```
Get-SteamFriendList -SteamID64 76561197960435530
```

Outputs the user's friends list, as an array of friends.

### EXAMPLE 2
```
Get-SteamFriendList -SteamID64 76561197960435530 | ConvertFrom-Json
```

Outputs the user's friends list, as an array of friends and converts it from
Json to PSCustomObjects.

## PARAMETERS

### -SteamID64
64 bit Steam ID to return friend list for.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Relationship
Relationship filter.
Possibles values: all, friend.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
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
Position: 3
Default value: Json
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### int64
## OUTPUTS

### Returns a string that is either formatted as json, xml or vdf.
### The user's friends list, as an array of friends. Nothing will be returned
### if the profile is private.
### In the array, the following three properties are returned:
### - steamid: 64 bit Steam ID of the friend.
### - relationship: Relationship qualifier.
### - friend_since: Unix timestamp of the time when the relationship was created.
## NOTES
Author: Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Get-SteamFriendList.html](https://hjorslev.github.io/SteamPS/Get-SteamFriendList.html)

