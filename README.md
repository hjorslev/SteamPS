# SteamPS

## Build Status

[![AppVeyor master](https://img.shields.io/appveyor/ci/hjorslev/SteamPS/master?label=AppVeyor&logo=appveyor&style=flat)](https://ci.appveyor.com/project/hjorslev/steamps)
[![Azure DevOps builds](https://img.shields.io/azure-devops/build/fhjorslev/69d18b04-0023-433d-a649-bcf821875235/5?label=Azure+Pipelines&logo=azure-pipelines)](https://dev.azure.com/fhjorslev/SteamPS/_build/latest?definitionId=5&branchName=master)
[![AppVeyor tests (master)](https://img.shields.io/appveyor/tests/hjorslev/SteamPS/master?label=master&logo=appveyor&style=flat)](https://ci.appveyor.com/project/hjorslev/steamps/build/tests)
[![Codacy master grade](https://img.shields.io/codacy/grade/bf0bb30dfc904b2f885c4f0ccdf1ea78/master?label=master&style=flat)](https://app.codacy.com/manual/hjorslev/SteamPS/dashboard?bid=13716491)

## Introduction

[![PowerShell Version](https://img.shields.io/powershellgallery/v/SteamPS.svg?style=flat&logo=PowerShell)](https://www.powershellgallery.com/packages/SteamPS)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/SteamPS?style=flat)](https://www.powershellgallery.com/packages/SteamPS)

This cmdlet utilizes SteamCMD and eases the installation and updating of servers.

Install or update a Steam application using SteamCMD.
You can either enter the specific Application ID or search for the application
by name. If there are multiple hits on the name, an Out-GridView will be presented
letting you choose the right application to install.

## Requirements

PowerShell 5.1

You can find your version of PowerShell by using:

```powershell
$PSVersionTable.PSVersion
```

## Installation

The module is published in the [PowerShell Gallery](https://www.powershellgallery.com/packages/SteamPS).

Run the following in an elevated prompt:

```powershell
Install-Module -Name SteamPS
```

When SteamPS is installed we will need to use the cmdlet `Install-SteamCMD` from
the module to install SteamCMD. This is done by calling Install-SteamCMD from an
elevated prompt:

```powershell
Install-SteamCMD
```

By using the parameter `-InstallPath` you can specify an install location of SteamCMD.

## Cmdlets

| Cmdlet                                                                             | Description                                                     |
| ---------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| [Find-SteamAppID](https://hjorslev.github.io/SteamPS/Find-SteamAppID.html)         | Find a Steam AppID by searching the name of the application.    |
| [Get-SteamServerInfo](https://hjorslev.github.io/SteamPS/Get-SteamServerInfo.html) | Query a running steam based game server.                        |
| [Install-SteamCMD](https://hjorslev.github.io/SteamPS/Install-SteamCMD.html)       | Install SteamCMD.                                               |
| [Update-SteamApp](https://hjorslev.github.io/SteamPS/Update-SteamApp.html)         | Install or update a Steam application using SteamCMD.           |
| [Update-SteamServer](https://hjorslev.github.io/SteamPS/Update-SteamServer.html)   | Update a Steam based game server through a particular workflow. |

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

### Update Steam server automatically

The cmdlet Update-SteamServer is, at least for my own use case, applied to automatically
keep a server up-to-date. It will check the if the server is empty before updating
it.

Please see the wiki for further information: [Update Steam server automatically](https://github.com/hjorslev/SteamPS/wiki/Update-Steam-server-automatically)
