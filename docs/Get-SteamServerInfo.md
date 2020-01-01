---
external help file: SteamPS-help.xml
Module Name: steamps
online version: https://hjorslev.github.io/SteamPS/Get-SteamServerInfo.html
schema: 2.0.0
---

# Get-SteamServerInfo

## SYNOPSIS
Get server information about Steam game servers.

## SYNTAX

```
Get-SteamServerInfo [-ServerID] <String> [<CommonParameters>]
```

## DESCRIPTION
Get server information about Steam game servers from Rust Server Info (RSI).
Servers must be added at https://api.rust-servers.info/ prior to using this app.

## EXAMPLES

### EXAMPLE 1
```
Get-SteamServerInfo -ServerID 2743
```

## PARAMETERS

### -ServerID
Enter server ID from Rust Server Info.
A list of all servers can be found at
https://rust-servers.info/all-servers.html - ID is located in the URL e.g.
https://rust-servers.info/server/id-2743.html

```yaml
Type: String
Parameter Sets: (All)
Aliases: ID

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String. Get-SteamServer accepts a string value.
## OUTPUTS

## NOTES
Author: Frederik Hjorslev Poulsen

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Get-SteamServerInfo.html](https://hjorslev.github.io/SteamPS/Get-SteamServerInfo.html)

