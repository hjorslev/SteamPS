---
external help file: SteamPS-help.xml
Module Name: SteamPS
online version: https://hjorslev.github.io/SteamPS/Install-SteamCMD.html
schema: 2.0.0
---

# Install-SteamCMD

## SYNOPSIS
Install SteamCMD.

## SYNTAX

```
Install-SteamCMD [[-InstallPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet downloads SteamCMD and configures it in a custom or
predefined location (C:\Program Files\SteamCMD).

## EXAMPLES

### EXAMPLE 1
```
Install-SteamCMD
```

Installs SteamCMD in C:\Program Files\SteamCMD.

### EXAMPLE 2
```
Install-SteamCMD -InstallPath 'C:\SteamCMD'
```

Installs SteamCMD in C:\SteamCMD.

## PARAMETERS

### -InstallPath
Specifiy the install location of SteamCMD.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Frederik Hjorslev Poulsen

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Install-SteamCMD.html](https://hjorslev.github.io/SteamPS/Install-SteamCMD.html)

