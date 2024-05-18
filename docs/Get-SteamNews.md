---
external help file: SteamPS-help.xml
Module Name: SteamPS
online version: https://hjorslev.github.io/SteamPS/Get-SteamNews.html
schema: 2.0.0
---

# Get-SteamNews

## SYNOPSIS
Returns the latest news of a game specified by its AppID.

## SYNTAX

```
Get-SteamNews [-AppID] <Int32> [[-Count] <Int32>] [[-MaxLength] <Int32>] [-ProgressAction <ActionPreference>]
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32
## OUTPUTS

### Outputs an object containing:
### - GID: The ID of the news item.
### - Title: The title of the news item.
### - Url: The URL of the news item.
### - IsExternalUrl: A boolean indicating if the URL is external.
### - Author: The author of the news item.
### - Contents: The content of the news item.
### - FeedLabel: The label of the news feed.
### - Date: The date and time when the news item was published.
### - FeedName: The name of the news feed.
### - FeedType: The type of the news feed.
### - AppID: The AppID of the game associated with the news item.
## NOTES
Author: Frederik Hjorslelv Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Get-SteamNews.html](https://hjorslev.github.io/SteamPS/Get-SteamNews.html)

