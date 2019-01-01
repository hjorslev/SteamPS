# SteamPS

## Introduction

This cmdlet utilize SteamCMD and eases the installation and updating of servers.

Install or update a Steam application using SteamCMD. If SteamCMD is missing, it will be installed first before installing any application.

You can either search for the application by name or enter the specific Application ID.

## Requirements

PowerShell 5.0

You can find your version of PowerShell by using

```powershell
$PSVersionTable.PSVersion
```

## Installation

The module is published in the [PowerShell Gallery](https://www.powershellgallery.com/packages/SteamPS).

Run the following in an elevated prompt:

```powershell
Install-Module -Name SteamPS
```

You can also install the module for the current user without admin privileges:

```powershell
Install-Module -Name SteamPS -Scope CurrentUser
```

## Examples

```powershell
# Add a game / server by searching for its name. Because there are multiple hits when searching for Arma 3, the user will be promoted to select the right application.
Update-SteamApp -GameName 'Arma 3' -Credential Toby -Path 'C:\Servers\Arma3'

# Here we use anonymous login because the particular application (ARK: Survival Evolved Dedicated Server) doesn't require login.
Update-SteamApp -AppID 376030 -Path 'C:\Servers\Arma3'
```
