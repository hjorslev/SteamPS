# SteamPS

## Introduction

Install or update a Steam application using SteamCMD. If SteamCMD is missing, it will be installed first before installing any application.

You can either search for the application by name or enter the specific Application ID.

## Requirements

PowerShell 5.0

You can find your version of PowerShell by using

```powershell
$PSVersionTable.PSVersion
```

## Examples

```powershell
# Because there are multiple hits when searching for Arma 3, the user will be promoted to select the right application.
Update-SteamApp -GameName 'Arma 3' -SteamUserName 'user' -SteamPassword 'pass' -Path 'C:\Servers'

# Here we use anonymous login because the particular application (ARK: Survival Evolved Dedicated Server) doesn't require login.
Update-SteamApp -AppID 376030 -Path 'C:\Servers'
```
