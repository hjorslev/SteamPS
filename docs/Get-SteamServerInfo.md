---
external help file: SteamPS-help.xml
Module Name: steamps
online version: https://hjorslev.github.io/SteamPS/Get-SteamServerInfo.html
schema: 2.0.0
---

# Get-SteamServerInfo

## SYNOPSIS
Query a running steam based game server.

## SYNTAX

```
Get-SteamServerInfo [-IPAddress] <IPAddress> [-Port] <Int32> [[-Timeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The cmdlet fetches server information from a running game server using UDP/IP packets.
It will return information ServerName, Map, InstallDir, GameName, AppID, Players
MaxPlayers, Bots, ServerType, Environment, Visibility, VAC andVersion.

## EXAMPLES

### EXAMPLE 1
```
Get-SteamServerInfo -IPAddress '185.15.73.207' -Port 27015
```

\`\`\`
Protocol      : 17
ServerName    : SAS Proving Ground 10 (EU)
Map           : TH-SmallTown
InstallDir    : groundbranch
GameName      : Ground Branch
AppID         : 16900
Players       : 6
MaxPlayers    : 10
Bots          : 0
ServerType    : Dedicated
Environment   : Windows
Visibility    : Public
VAC           : Unsecured
Version       : 1.0.0.0
ExtraDataFlag : 177
IPAddress     : 185.15.73.207
Port          : 27015
\`\`\`

## PARAMETERS

### -IPAddress
Enter the IP address of the Steam based server.

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Enter the port number of the Steam based server.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Timeout in milliseconds before giving up querying the server.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 5000
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Jordan Borean, Chris Dent and Frederik Hjorslev Poulsen

## RELATED LINKS

[https://hjorslev.github.io/SteamPS/Get-SteamServerInfo.html](https://hjorslev.github.io/SteamPS/Get-SteamServerInfo.html)

