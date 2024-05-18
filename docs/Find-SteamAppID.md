---
external help file: SteamPS-help.xml
Module Name: SteamPS
online version: https://hjorslev.github.io/SteamPS/Find-SteamAppID.html
schema: 2.0.0
---

# Find-SteamAppID

## SYNOPSIS
Find a Steam AppID by searching the name of the application.

## SYNTAX

## DESCRIPTION
Find a Steam AppID by searching the name of the application.

## EXAMPLES

### EXAMPLE 1
```
Find-SteamAppID -ApplicationName 'Ground Branch'
```

Will results in multiple hits and let the user choose between the application
'Ground Branch' which is the game or 'Ground Branch Dedicated Server' which
is the dedicated server to 'Ground Branch'.

### EXAMPLE 2
```
Find-SteamAppID -ApplicationName 'Ground Branch D'
```

This Will only yield one result which is 'Ground Branch Dedicated Server'.
Output is the AppID and name of the application.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String or System.Int32. Get-SteamApp accepts either a string value for the application name or an integer value for the application ID.
## OUTPUTS

### PSCustomObject. This function returns a custom object with the application name and application ID.
## NOTES
Author: Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Find-SteamAppID.html](https://hjorslev.github.io/SteamPS/Find-SteamAppID.html)

