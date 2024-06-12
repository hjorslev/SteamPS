---
external help file: SteamPS-help.xml
Module Name: SteamPS
online version: https://hjorslev.github.io/SteamPS/Connect-SteamAPI.html
schema: 2.0.0
---

# Connect-SteamAPI

## SYNOPSIS
Create or update the Steam Web API config file.

## SYNTAX

```
Connect-SteamAPI [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Create or update the Steam Web API config file which contains the API key
used to authenticate to those Steam Web API's that require authentication.

## EXAMPLES

### EXAMPLE 1
```
Connect-SteamAPI
```

Prompts the user for a Steam Web API key and sets the specified input within
the config file.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Connect-SteamAPI.
## OUTPUTS

### None. Nothing is returned when calling Connect-SteamAPI.
## NOTES
Author: sysgoblin (https://github.com/sysgoblin) and Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Connect-SteamAPI.html](https://hjorslev.github.io/SteamPS/Connect-SteamAPI.html)

