---
external help file: SteamPS-help.xml
Module Name: steamps
online version: https://hjorslev.github.io/SteamPS/Update-SteamApp.html
schema: 2.0.0
---

# Update-SteamApp

## SYNOPSIS
Install or update a Steam application using SteamCMD.

## SYNTAX

### ApplicationName
```
Update-SteamApp [-ApplicationName] <String> -Path <String> [-Credential <PSCredential>] [-Arguments <String>]
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### AppID
```
Update-SteamApp [-AppID] <Int32> -Path <String> [-Credential <PSCredential>] [-Arguments <String>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Install or update a Steam application using SteamCMD.
If SteamCMD is missing, it will be installed first.
You can either search for the application by name or enter the specific Application ID.

## EXAMPLES

### EXAMPLE 1
```
Update-SteamApp -ApplicationName 'Arma 3' -Credential 'Toby' -Path 'C:\Servers\Arma3'
```

Because there are multiple hits when searching for Arma 3, the user will be promoted to select the right application.

### EXAMPLE 2
```
Update-SteamApp -AppID 376030 -Path 'C:\Servers'
```

Here we use anonymous login because the particular application (ARK: Survival Evolved Dedicated Server) doesn't require login.

## PARAMETERS

### -ApplicationName
Enter the name of the app to make a wildcard search for the application.

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

### -AppID
Enter the application ID you wish to install.

```yaml
Type: Int32
Parameter Sets: AppID
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
Path to installation folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
If the app requires login to install or update, enter your Steam username and password.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [System.Management.Automation.PSCredential]::Empty
Accept pipeline input: False
Accept wildcard characters: False
```

### -Arguments
Enter any additional arguments here.

Beware, the following arguments are already used:

If you use Steam login to install/upload the app the following arguments are already used: "+login $SteamUserName $SteamPassword +force_install_dir $Path +app_update $SteamAppID $Arguments validate +quit"

If you use anonymous login to install/upload the app the following arguments are already used: "+login anonymous +force_install_dir $Path +app_update $SteamAppID $Arguments validate +quit"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Frederik Hjorslev Poulsen

SteamCMD CLI parameters: https://developer.valvesoftware.com/wiki/Command_Line_Options#Command-line_parameters_4

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Update-SteamApp.html](https://hjorslev.github.io/SteamPS/Update-SteamApp.html)

