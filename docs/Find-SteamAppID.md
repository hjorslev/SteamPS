---
external help file: SteamPS-help.xml
Module Name: steamps
online version: https://hjorslev.github.io/SteamPS/Find-SteamAppID.html
schema: 2.0.0
---

# Find-SteamAppID

## SYNOPSIS
Find a Steam AppID by searching using the name of the application.

## SYNTAX

```
Find-SteamAppID [-ApplicationName] <String> [<CommonParameters>]
```

## DESCRIPTION
Find a Steam AppID by searching using the name of the application.

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

### -ApplicationName
Enter the name of the application.
If multiple hits the user will be presented
with an Out-GridView where he/she can choose the correct application.

```yaml
Type: String
Parameter Sets: (All)
Aliases: GameName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String. Find-SteamAppID accepts a string value.
## OUTPUTS

### System.String and Int. It returns the application name and application ID.
## NOTES
Author: Frederik Hjorslev Poulsen

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Find-SteamAppID.html](https://hjorslev.github.io/SteamPS/Find-SteamAppID.html)

