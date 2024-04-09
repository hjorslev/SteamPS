---
external help file: SteamPS-help.xml
Module Name: SteamPS
online version: https://hjorslev.github.io/SteamPS/Disconnect-SteamAPI.html
schema: 2.0.0
---

# Disconnect-SteamAPI

## SYNOPSIS
Disconnects from the Steam API by removing the stored API key.

## SYNTAX

```
Disconnect-SteamAPI [-Force] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Disconnect-SteamAPI cmdlet removes the stored Steam API key from the system.
This effectively disconnects the current session from the Steam API.

## EXAMPLES

### EXAMPLE 1
```
Disconnect-SteamAPI -Force
```

This command will remove the stored Steam API key without asking for confirmation.

## PARAMETERS

### -Force
When the Force switch is used, the cmdlet will skip the confirmation prompt and directly remove the API key.

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

### None. You cannot pipe objects to Disconnect-SteamAPI.
## OUTPUTS

### None. Nothing is returned when calling Disconnect-SteamAPI.
## NOTES
Author: Frederik Hjorslev Nylander

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Disconnect-SteamAPI.html](https://hjorslev.github.io/SteamPS/Disconnect-SteamAPI.html)

