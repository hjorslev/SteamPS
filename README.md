# SteamPS

[![AppVeyor master](https://img.shields.io/appveyor/ci/hjorslev/SteamPS/master?label=AppVeyor&logo=appveyor&style=flat)](https://ci.appveyor.com/project/hjorslev/steamps)
[![Azure DevOps builds](https://img.shields.io/azure-devops/build/fhjorslev/69d18b04-0023-433d-a649-bcf821875235/5?label=Azure+Pipelines&logo=azure-pipelines)](https://dev.azure.com/fhjorslev/SteamPS/_build/latest?definitionId=5&branchName=master)
[![AppVeyor tests (master)](https://img.shields.io/appveyor/tests/hjorslev/SteamPS/master?label=master&logo=appveyor&style=flat)](https://ci.appveyor.com/project/hjorslev/steamps/build/tests)
[![Codacy master grade](https://img.shields.io/codacy/grade/bf0bb30dfc904b2f885c4f0ccdf1ea78/master?label=master&style=flat)](https://app.codacy.com/manual/hjorslev/SteamPS/dashboard?bid=13716491)

## Introduction

[![PowerShell Version](https://img.shields.io/powershellgallery/v/SteamPS.svg?style=flat&logo=PowerShell)](https://www.powershellgallery.com/packages/SteamPS)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/SteamPS?style=flat)](https://www.powershellgallery.com/packages/SteamPS)

SteamPS is a [PowerShell module](https://github.com/PowerShell/PowerShell/) that
can interact with [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD),
a command-line version of the Steam client.

SteamPS is aimed at server administrators maintaining one or more servers. It can
be used to install SteamCMD, update game servers, query Steam based game servers
for server information and more.

## Command Reference

| Cmdlet                                             | Description                                                     |
| -------------------------------------------------- | --------------------------------------------------------------- |
| [Find-SteamAppID](docs/Find-SteamAppID.md)         | Find a Steam AppID by searching the name of the application.    |
| [Get-SteamServerInfo](docs/Get-SteamServerInfo.md) | Query a running Steam based game server.                        |
| [Install-SteamCMD](docs/Install-SteamCMD.md)       | Install SteamCMD.                                               |
| [Update-SteamApp](docs/Update-SteamApp.md)         | Install or update a Steam application using SteamCMD.           |
| [Update-SteamServer](docs/Update-SteamServer.md)   | Update a Steam based game server through a particular workflow. |

## Prerequisites

- Windows based OS
- Windows PowerShell 5.1 / PowerShell 6+

You can find your version of PowerShell by using:

```powershell
$PSVersionTable.PSVersion
```

## Getting Started

### Install from PowerShell Gallery

The module is published in the [PowerShell Gallery](https://www.powershellgallery.com/packages/SteamPS).

Run the following in an elevated prompt to install the module for all users on
the server:

```powershell
Install-Module -Name SteamPS
```

The module can also be installed in the current user's scope by adding
`-Scope CurrentUser` to the above. If you are multiple administrators
it can be easier to maintain the module by having SteamPS installed in
one location.

When SteamPS is installed we will need to use the cmdlet `Install-SteamCMD` from
the module to install SteamCMD. This is done by calling Install-SteamCMD from an
elevated prompt:

```powershell
Install-SteamCMD
```

By using the parameter `-InstallPath` you can specify an install location of SteamCMD.
The default installation path is C:\Program Files\SteamCMD which is also added to
the [PATH](https://en.wikipedia.org/wiki/PATH_(variable)).

### Usage

### Update single app / game server

The cmdlet `Update-SteamApp` is used to update an application as well as installing
an application from scratch. You can either specify the name of the application or
the application ID.

#### Install / Update using ApplicationName

Notice that if you e.g. enter *Ground Branch* as application name you will see
both the game itself as well as the dedicated server. You will have to select the
correct application from the popup box.

![Select application](assets/images/select-application.png | width=300)

In the example below we typed the entire name of the application which does not
yield a popup box.

```powershell
Update-SteamApp -ApplicationName 'Ground Branch Dedicated Server' -Path 'C:\DedicatedServers\GB'
```

#### Install / Update using AppID

In this example we install *ARK: SurvivalEvolved Dedicated Server* by using its
AppID. The AppID can be found by using a database such as
[Steam Database](https://steamdb.info/) or by searching for it with the cmdlet
`Find-SteamAppID`.

```powershell
Update-SteamApp -AppID 376030 -Path 'C:\DedicatedServers\ARK-SurvivalEvolved'
```

#### Authenticating

The two previous example does not require authentication to install. Before being
able to install some application you might need a Steam account.

To authenticate you can use the parameter `-Credential`:

```powershell
Update-SteamApp -ApplicationName 'Ground Branch Dedicated Server' -Path 'C:\DedicatedServers\GB' -Credential SAS_Admin
```

This will present you with an option to type in your password.

In case you need to authenticate and want to run the script unattended avoid writing
the password in plaintext in the script. See [Store Credentials in PowerShell Script](https://pscustomobject.github.io/powershell/howto/Store-Credentials-in-PowerShell-Script/#store-encrypted-password-in-an-external-file)

### Update Steam server automatically

The cmdlet `Update-SteamServer` is, at least for my own use case, applied to automatically
keep a server up-to-date. It will check the if the server is empty before updating
it.

Please see the wiki for further information: [Update Steam server automatically](https://github.com/hjorslev/SteamPS/wiki/Update-Steam-server-automatically)
