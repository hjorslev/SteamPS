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

| Cmdlet                                             | Description                                                  |
| -------------------------------------------------- | ------------------------------------------------------------ |
| [Find-SteamAppID](docs/Find-SteamAppID.md)         | Find a Steam AppID by searching the name of the application. |
| [Get-SteamServerInfo](docs/Get-SteamServerInfo.md) | Query a running Steam based game server.                     |
| [Install-SteamCMD](docs/Install-SteamCMD.md)       | Install SteamCMD.                                            |
| [Update-SteamApp](docs/Update-SteamApp.md)         | Install or update a Steam application using SteamCMD.        |
| [Update-SteamServer](docs/Update-SteamServer.md)   | Update a Steam based game server through a workflow.         |

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

Run the following in an elevated prompt to install the module globally for all
users on the server:

```powershell
Install-Module -Name SteamPS
```

The module can also be installed in the current user's scope by adding
`-Scope CurrentUser` to the above mentioned command. If multiple people are administrating
the server, it can be easier to maintain the module by having SteamPS installed in
just one location.

Furthermore, if you plan to have cmdlets from the module running unattended
you will need to make sure that the module is available to the user running it. This
can be achieved by ensuring the module is installed for the user running it, or just
have it installed globally for all users as exemplified above.

When SteamPS is installed you will need to use the cmdlet `Install-SteamCMD` from
the module to install SteamCMD. This is done by calling `Install-SteamCMD` from an
elevated prompt:

```powershell
Install-SteamCMD
```

<img src="/assets/images/install-steamcmd.gif" alt="Select application" width="700px"/>

By using the parameter `-InstallPath` you can specify an install location of SteamCMD.
The default installation path is C:\Program Files\SteamCMD. The install path,
default or custom, is added to the [PATH](https://en.wikipedia.org/wiki/PATH_(variable)).

### Usage

#### Update single app / game server

The cmdlet `Update-SteamApp` is used to both install and/or update an application.
You can either specify the name of the application or the application ID.

#### Install / Update using ApplicationName

If you enter e.g. *Ground Branch* as an application name you will see
both the game itself as well as the dedicated server. You will have to select the
correct application from the popup box.

```powershell
Update-SteamApp -ApplicationName 'Ground Branch' -Path 'C:\DedicatedServers\GB'
```

<img src="/assets/images/select-application.png" alt="Select application" width="700px"/>

You can narrow down the search by typing an application name that is more specific
than simply *Ground Branch* e.g. *Ground Branch Dedi* or type it out
in its entirety as *Ground Branch Dedicated Server*. This will only give one result
and not display a popup.

```powershell
Update-SteamApp -ApplicationName 'Ground Branch Dedicated Server' -Path 'C:\DedicatedServers\GB'
```

<img src="/assets/images/update-steamapp.gif" alt="Select application" width="700px"/>

#### Install / Update using AppID

In this example we install *ARK: SurvivalEvolved Dedicated Server* by using its
AppID. The AppID can be found by using a database such as
[Steam Database](https://steamdb.info/) or by searching for the AppID with the cmdlet
`Find-SteamAppID` e.g. `Find-SteamAppID -ApplicationName 'Counter-Strike'`.

```powershell
Update-SteamApp -AppID 376030 -Path 'C:\DedicatedServers\ARK-SurvivalEvolved'
```

#### Authenticating

The two previous examples do not require authentication to install. However, some
applications might require a Steam account. If that is the case, you will need to
use the parameter `-Credential` to authenticate:

```powershell
Update-SteamApp -ApplicationName 'Ground Branch Dedicated Server' -Path 'C:\DedicatedServers\GB' -Credential SAS_Admin
```

This will present you with an option to type in your password.

In case you need to authenticate and want to run the script unattended, avoid writing
the password in plaintext in the script. See how this can be achieved:
[Store Credentials in PowerShell Script](https://pscustomobject.github.io/powershell/howto/Store-Credentials-in-PowerShell-Script/#store-encrypted-password-in-an-external-file).

### Update Steam server automatically

The cmdlet `Update-SteamServer` is, at least for my own use case, applied to automatically
keep a server up to date. It will check if the server is empty before updating
it. The script is configured as a [Windows Task](https://o365reports.com/2019/08/02/schedule-powershell-script-task-scheduler/)
and runs very night.

Please see the wiki for further information: [Update Steam server automatically](https://github.com/hjorslev/SteamPS/wiki/Update-Steam-server-automatically).
