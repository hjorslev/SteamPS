---
external help file: SteamPS-help.xml
Module Name: SteamPS
online version: https://hjorslev.github.io/SteamPS/Resolve-VanityURL.html
schema: 2.0.0
---

# Resolve-VanityURL

## SYNOPSIS
Resolve a vanity URL (also named custom URL).

## SYNTAX

```
Resolve-VanityURL [-VanityURL] <String> [[-UrlType] <Int32>] [[-OutputFormat] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Resolve a vanity URL (also named custom URL) and return the 64 bit SteamID
that belongs to said URL.

## EXAMPLES

### EXAMPLE 1
```
Resolve-VanityURL -VanityURL hjorslev
```

Returns a 64 bit Steam ID.

## PARAMETERS

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

### -UrlType
The type of vanity URL.
1 (default): Individual profile, 2: Group, 3: Official game group

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -VanityURL
Enter the vanity URL (also named custom URL) to get a SteamID for.
Do not enter
the fully qualified URL, but just the ID e.g.
hjorslev instead of
"https://steamcommunity.com/id/hjorslev/"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String.
## OUTPUTS

### 64 bit Steam ID.
## NOTES
Author: Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Resolve-VanityURL.html](https://hjorslev.github.io/SteamPS/Resolve-VanityURL.html)

