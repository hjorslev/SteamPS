# SteamPS

## Build Status

[![AppVeyor master](https://img.shields.io/appveyor/ci/hjorslev/SteamPS/master?label=MASTER&logo=appveyor&style=flat)](https://ci.appveyor.com/project/hjorslev/steamps)
[![AppVeyor tests (master)](https://img.shields.io/appveyor/tests/hjorslev/SteamPS/master?label=MASTER&logo=appveyor&style=flat)](https://ci.appveyor.com/project/hjorslev/steamps/build/tests)
[![AppVeyor dev](https://img.shields.io/appveyor/ci/hjorslev/SteamPS/DEV?label=DEV&logo=appveyor&style=flat)](https://ci.appveyor.com/project/hjorslev/steamps)
[![AppVeyor tests (dev)](https://img.shields.io/appveyor/tests/hjorslev/SteamPS/dev?label=DEV&logo=appveyor&style=flat)](https://ci.appveyor.com/project/hjorslev/steamps/build/tests)
[![Codacy master grade](https://img.shields.io/codacy/grade/bf0bb30dfc904b2f885c4f0ccdf1ea78/master?label=MASTER&style=flat)](https://app.codacy.com/manual/hjorslev/SteamPS/dashboard?bid=13716491)
[![Codacy dev  grade](https://img.shields.io/codacy/grade/bf0bb30dfc904b2f885c4f0ccdf1ea78/dev?label=DEV&style=flat)](https://app.codacy.com/manual/hjorslev/SteamPS/dashboard?bid=13716490)

## Introduction

[![PowerShell Version](https://img.shields.io/powershellgallery/v/SteamPS.svg?style=flat&logo=PowerShell)](https://www.powershellgallery.com/packages/SteamPS)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/SteamPS?style=flat)](https://www.powershellgallery.com/packages/SteamPS)

This cmdlet utilizes SteamCMD and eases the installation and updating of servers.

Install or update a Steam application using SteamCMD.
You can either enter the specific Application ID or search for the application
by name. If there are multiple hits on the name, an Out-GridView will be presented
letting you choose the right application to install.

## Requirements

PowerShell 5.0

You can find your version of PowerShell by using:

```powershell
$PSVersionTable.PSVersion
```

## Installation

The module is published in the [PowerShell Gallery](https://www.powershellgallery.com/packages/SteamPS).

1. Run the following in an elevated prompt:

```powershell
Install-Module -Name SteamPS
```

When SteamPS is installed we will need to use the cmdlet `Install-SteamCMD` from
the module to install SteamCMD.
2. This is done by calling Install-SteamCMD from an elevated prompt:

```powershell
Install-SteamCMD
```

By using the parameter -InstallPath you can specify an install location of SteamCMD.

## Cmdlets

| Cmdlet              | Description                                                     |
| ------------------- | --------------------------------------------------------------- |
| Find-SteamAppID     | Find a Steam AppID by searching the name of the application.    |
| Get-SteamServerInfo | Query a running steam based game server.                        |
| Install-SteamCMD    | Install SteamCMD.                                               |
| Update-SteamApp     | Install or update a Steam application using SteamCMD.           |
| Update-SteamServer  | Update a Steam based game server through a particular workflow. |

## Examples

The cmdlets must be executed from an elevated prompt.

### Update single app / game server

Add a game / server by searching for its name. Because there are multiple hits
when searching for Arma 3, the user will be promoted to select the right application.

```powershell
Update-SteamApp -GameName 'Arma 3' -Credential Toby -Path 'C:\Servers\Arma3'
```

Here we use anonymous login because the particular application
(ARK: SurvivalEvolved Dedicated Server) doesn't require authentication to install
the server.

```powershell
Update-SteamApp -AppID 376030 -Path 'C:\Servers\ARK-SurvivalEvolved'
```

### Server update flow

The cmdlet Update-SteamServer is, at least for my own use case, applied to automatically
keep a server up-to-date. It will check the if the server is empty before updating
it.

Game servers must be ran as a [Windows Service](https://www.howtogeek.com/50786/using-srvstart-to-run-any-application-as-a-windows-service/).
There are also commercial programs available such as [FireDaemon](https://firedaemon.com/firedaemon-pro/).

#### Introduction

Per default, all servers are installed at `C:\DedicatedServers\$ServiceName`. This
can be altered using the `-ApplicationPath` parameter.

If you want to have your server automatically updated, then remember to consider
backup of the server as well as fallback.

```powershell
Update-SteamServer -AppID 476400 -ServiceName 'GB-PG10' -IPAddress '185.15.73.207' -Port 27015
```

1. `Update-SteamServer` will fetch the server info to check if the server is empty.
If not, it will wait until the server is empty before updating.
2. It will stop the server by stopping the  Windows Service named *GB-PG10*.
3. It will update the server.
4. When the server is updated it will check to see that the server is online. Default
is to check every minute for a maximum of 10 times before the server is declared
offline.
   1. By specifying the parameter `-DiscordWebhookUri` you can have a notification
   if the server fails to update.
   2. If you specify the parameter `-AlwaysNotify` alongside `-DiscordWebhookUri`
   you will always receive a message with a status of the server update.
