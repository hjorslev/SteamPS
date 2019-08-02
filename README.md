# SteamPS

## Build Status

[![AppVeyor master](https://img.shields.io/appveyor/ci/hjorslev/SteamPS/master?label=MASTER&logo=appveyor&style=for-the-badge)](https://ci.appveyor.com/project/hjorslev/steamps)
[![AppVeyor tests (master)](https://img.shields.io/appveyor/tests/hjorslev/SteamPS/master?label=MASTER&logo=appveyor&style=for-the-badge)](https://ci.appveyor.com/project/hjorslev/steamps/build/tests)
[![AppVeyor dev](https://img.shields.io/appveyor/ci/hjorslev/SteamPS/DEV?label=DEV&logo=appveyor&style=for-the-badge)](https://ci.appveyor.com/project/hjorslev/steamps)
[![AppVeyor tests (dev)](https://img.shields.io/appveyor/tests/hjorslev/SteamPS/dev?label=DEV&logo=appveyor&style=for-the-badge)](https://ci.appveyor.com/project/hjorslev/steamps/build/tests)
[![PowerShell Version](https://img.shields.io/powershellgallery/v/SteamPS.svg?style=for-the-badge&logo=PowerShell)](https://www.powershellgallery.com/packages/SteamPS)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/SteamPS?style=for-the-badge)](https://www.powershellgallery.com/packages/SteamPS)

## Introduction

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

## Examples

The cmdlets must be executed from an elevated prompt.

```powershell
# Add a game / server by searching for its name. Because there are multiple hits when searching for Arma 3, the user will be promoted to select the right application.
Update-SteamApp -GameName 'Arma 3' -Credential Toby -Path 'C:\Servers\Arma3'

# Here we use anonymous login because the particular application (ARK: Survival Evolved Dedicated Server) doesn't require login.
Update-SteamApp -AppID 376030 -Path 'C:\Servers\Arma3'
```
