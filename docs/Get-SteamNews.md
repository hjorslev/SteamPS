---
external help file: SteamPS-help.xml
Module Name: steamps
online version: https://hjorslev.github.io/SteamPS/Get-SteamNews.html
schema: 2.0.0
---

# Get-SteamNews

## SYNOPSIS
Returns the latest news of a game specified by its AppID.

## SYNTAX

```
Get-SteamNews [-AppID] <Int32> [[-Count] <Int32>] [[-MaxLength] <Int32>] [[-OutputFormat] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns the latest news of a game specified by its AppID.

## EXAMPLES

### EXAMPLE 1
```
Get-SteamNews -AppID 440
```

Lists number of news that are available for the AppID.

### EXAMPLE 2
```
Get-SteamNews -AppID 440 -Count 1
```

Retrieves 1 (the latest) news item for the AppID 440.

## PARAMETERS

### -AppID
AppID of the game you want the news of.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Count
How many news entries you want to get returned.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxLength
Maximum length of each news entry.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
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
Position: 4
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
### An appnews object containing:
### appid, the AppID of the game you want news of
### newsitems, an array of news item information:
### - An ID, title and url.
### - A shortened excerpt of the contents (to maxlength characters), terminated by "..." if longer than maxlength.
### - A comma-separated string of labels and UNIX timestamp.
## NOTES
Author: Frederik Hjorslelv Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Get-SteamNews.html](https://hjorslev.github.io/SteamPS/Get-SteamNews.html)

