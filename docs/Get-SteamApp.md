---
external help file: SteamPS-help.xml
Module Name: SteamPS
online version: https://hjorslev.github.io/SteamPS/Get-SteamApp.html
schema: 2.0.0
---

# Get-SteamApp

## SYNOPSIS
Retrieves the name and ID of a Steam application by searching the name or
ID of the application.

## SYNTAX

### ApplicationName (Default)
```
Get-SteamApp [-ApplicationName] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ApplicationID
```
Get-SteamApp [-ApplicationID] <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function searches for a Steam application by name or ID and returns the
corresponding application ID and name.
If multiple applications are found,
the user can select the correct one from a list.

## EXAMPLES

### EXAMPLE 1
```
Get-SteamApp -ApplicationName 'Ground Branch'
```

Searches for applications with names that start with 'Ground Branch'.
If multiple applications are found, the user can choose between them, such as the game 'Ground Branch' or 'Ground Branch Dedicated Server'.

### EXAMPLE 2
```
Get-SteamApp -ApplicationID 440
```

Searches for the application with the AppID 440 and returns its name and ID.

## PARAMETERS

### -ApplicationID
The unique identifier for a Steam application.
Use this parameter to search for an application by its ID.

```yaml
Type: Int32
Parameter Sets: ApplicationID
Aliases: GameID

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApplicationName
The name of the application to search for.
If multiple applications are found,
the user will be presented with a list from which they can select the correct application.

```yaml
Type: String
Parameter Sets: ApplicationName
Aliases: GameName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### System.String or System.Int32. Get-SteamApp accepts either a string value for the application name or an integer value for the application ID.
## OUTPUTS

### PSCustomObject. This function returns a custom object with the application name and application ID.
## NOTES
Author: Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Get-SteamApp.html](https://hjorslev.github.io/SteamPS/Get-SteamApp.html)

