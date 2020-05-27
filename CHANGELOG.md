# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/)
and this project adheres to [Semantic Versioning](https://semver.org/).

## Unreleased

### Changed

- Improving structure / format of the code.
  - Remove the subexpression where they are not needed.

## [3.0.0] - 19/05-2020

### Fixed

- Place external help inside module folder instead of the project folder.

### Changed

- Update-SteamServer
  - Change parameter ApplicationPath to Path. Set old parameter as an alias.
  - Change parameter LogLocation to LogPath. Set old parameter as an alias.
- Get-SteamServerInfo
  - The cmdlet now uses Steam server queries to fetch data about the server. Added
  new parameters `-IPAddress`, `-Port` and `-Timeout`. Removed parameter `-ServerID`
  since the cmdlet is no longer dependent on Rust Server Info.

## [2.0.3] - 05/01-2020

### Added

- Update-SteamServer
  - Add `Arguments` parameter.

## [2.0.2] - 22/12-2019

### Changed

- New workflow with [InvokeBuild](https://github.com/nightroman/Invoke-Build).
- Update-SteamServer
  - Changed default to only send Discord notification on errors. Introduce new
  parameter `AlwaysNotify` to always send notifications (fix #3).

### Added

- Update-SteamServer
  - Add new parameter `TimeoutLimit` to allow the customization of the timeout.
  Default is 10 loops before an error is thrown.

## [2.0.1] - 02/09-2019

### Fixed

- Update-SteamApp
  - Validate that parameter *Path* does not contain a trailing slash as it breaks
  SteamCMD.

## [2.0.0] - 05/08-2019

### Added

- Module [Logging](https://www.powershellgallery.com/packages/Logging) is listed
as dependency.
- New cmdlet: Update-SteamServer
  - Cmdlet that presents a workflow to keep a Steam based game server up to date.

### Changed

- New workflow with AppVeyor.
- Move `#Requires -RunAsAdministrator` statement from module file to the cmdlets
that requires administrator priviliges (Install-SteamCMD, Update-SteamApp,
Update-SteamServer) allowing some cmdlets to be executed without administrator
priviliges (Find-SteamAppID, Get-SteamServerInfo).
- Use `$env:Path` instead of registry database to handle the install location of
SteamCMD.

## [1.2.1] - 17/07-2019

### Added

- Add link to online help for all cmdlets.
- New cmdlet: Get-SteamServerInfo
  - Get server information about game servers from [Rust Server Info (RSI)](https://rust-servers.info).
- New-cmdlet: Find-SteamAppID
  - Moved functionality from Update-SteamApp into its own cmdlet allowing the
  user to use it as a standalone cmdlet as well.

### Changed

- Update-SteamApp
  - Change parameter *GameName* to *ApplicationName*. Add *GameName* as an alias
  to *ApplicationName*.

## [1.2.0] - 02/07-2019

### Changed

- Install-SteamCMD
  - Set predefined install path to Program Files in system drive.
  - Allow users to choose a custom install path of SteamCMD.

## [1.1.3] - 01/03-2019

### Fixed

- Install-SteamCMD
  - Fix Undefined Variable

## [1.1.0] - 27/01-2019

### Changed

- Split Update-SteamApp into Install-SteamCMD.

### Removed

- Remove temp file with SteamApp IDs. Instead, the newest list is always downloaded.

## [1.0.3] - 27/01-2019

### Added

- Add -UseBasicParsing to Invoke-WebRequest in order to support Windows Server Core.

## [1.0.2] - 08/01-2019

### Removed

- Remove templates files.

### Changed

- Update documentation.
- Update module description.

## [1.0.1] - 01/01-2019

### Removed

- Update-SteamApp
  - Remove check for version as it's done in SteamPS.psd1

## [1.0.0] - 01/01-2019

### Added

- Initial version
