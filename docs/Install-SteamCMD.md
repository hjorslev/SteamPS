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
Install-SteamCMD [[-InstallPath] <String>] [-Force] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
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
Install-SteamCMD -InstallPath 'C:'
```

Installs SteamCMD in C:\SteamCMD.

## PARAMETERS

### -Force
The Force parameter allows the user to skip the "Should Continue" box.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallPath
Specifiy the install location of SteamCMD.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "$env:ProgramFiles"
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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Install-SteamCMD.html](https://hjorslev.github.io/SteamPS/Install-SteamCMD.html)

