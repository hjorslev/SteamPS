---
external help file: SteamPS-help.xml
Module Name: steamps
online version: https://hjorslev.github.io/SteamPS/Update-SteamServer.html
schema: 2.0.0
---

# Update-SteamServer

## SYNOPSIS
Update a Steam based game server.

## SYNTAX

```
Update-SteamServer [-AppID] <Int32> [-ServiceName] <String> [-RsiServerID] <Int32>
 [[-ApplicationPath] <String>] [[-LogLocation] <String>] [[-DiscordWebhookUri] <String>]
 [[-AlwaysNotify] <String>] [[-TimeoutLimit] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet presents a workflow to keep a steam based game server up to date.
The server is expecting the game server to be running as a Windows Service.

## EXAMPLES

### EXAMPLE 1
```
Update-SteamServer -AppID 476400 -ServiceName GB-PG10 -RsiServerID 2743
```

## PARAMETERS

### -AppID
Enter the application ID you wish to install..

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

### -ServiceName
Specify the Windows Service Name.
You can get a list of services with Get-Service.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RsiServerID
Enter the Rust Server ID.
More information about adding and obtaining an ID:
https://rust-servers.info/add.html

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationPath
Install location of the game server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: "C:\DedicatedServers\$($ServiceName)"
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogLocation
Specify the location of the log files.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: "C:\DedicatedServers\Logs\$($ServiceName)\$($ServiceName)_$((Get-Date).ToShortDateString()).log"
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiscordWebhookUri
Enter a Discord Webhook Uri if you wish to get notifications about the server
update.,

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlwaysNotify
Use this if you allways want to receive a notification when a server has been
updated.
Default is only to send on errors.,

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutLimit
Number of times the cmdlet checks if the server is online or offline.
When
the limit is reached an error is thrown.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 10
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

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Update-SteamServer.html](https://hjorslev.github.io/SteamPS/Update-SteamServer.html)

