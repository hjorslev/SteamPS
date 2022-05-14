﻿# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/)
and this project adheres to [Semantic Versioning](https://semver.org/).

## [3.2.3] - 14/05-2022

### Fixed

- Get-SteamServerInfo
  - Fixes name property in output when no challenge is sent. Thanks [ThePoShWolf](https://github.com/ThePoShWolf)!

## [3.2.2] - 13/05-2022

Please note there were a minor error in Get-SteamServerInfo in this version.
Therefore, 3.2.2 has been hidden in the PowerShell Gallery.

### Fixed

- Get-SteamServerInfo
  - Support the server challenge request (Linux based servers) ([#47](https://github.com/hjorslev/SteamPS/issues/47)).
  Thanks [ThePoShWolf](https://github.com/ThePoShWolf)!
- Update-SteamApp
  - Fix a warning SteamCMD displays about the force_install_dir parameter needs to
  be called prior to the login parameter.

## [3.2.1] - 04/04-2021

### Fixe3

- Get-PacketString
  - Fixes an issue in `Get-SteamServerInfo` that caused the cmdlet to display an
  error when querying a Valheim server ([#41](https://github.com/hjorslev/SteamPS/issues/41)).
  Thanks [ThePoShWolf](https://github.com/ThePoShWolf)!

## [3.2.0] - 13/09-2020

### Added

- New cmdlets that can interact with the Steam Web API
  - Connect-SteamAPI
  - Get-SteamFriendList
  - Get-SteamNews
  - Get-SteamPlayerBan
  - Get-SteamPlayerSummary
  - Resolve-VanityURL

### Changed

- Logging is now handled using *PSFramework* rather than the module *Logging*. Output
of log files are stored in CSV format with more information about the system etc.
- Get-SteamServerInfo
  - Write the error, if the server cannot be reached, instead of throwing it. This
  is implemented because if the server could not be reached after using Update-SteamServer,
  the workflow would be terminated, the first time the server could not be reached,
  instead of attempting to test it again.

### Fixed

- Update-SteamServer
  - Fixed issue regarding the log file not being created due to a missing
  sub directory preventing any logging until the directory is created ([#29](https://github.com/hjorslev/SteamPS/issues/29)).
  - Fixed issue with the update workflow being corrupted if the server were offline
  at the beginning of the update ([#30](https://github.com/hjorslev/SteamPS/issues/30)).
- Update-SteamApp
  - Remove the validate parameter when calling SteamCMD. Validation will overwrite
  any files that have been changed. This may cause issues with customized
  servers ([#33](https://github.com/hjorslev/SteamPS/issues/33)).

## [3.1.1] - 12/07-2020

### Fixed

- Fix issue with error being thrown when adding SteamCMD location to PATH ([#24](https://github.com/hjorslev/SteamPS/issues/24)).
- Find-SteamAppID
  - Fix changed API url.

## [3.1.0] - 07/07-2020

### Added

- Update-SteamServer
  - Added `-Credential` parameter so apps that requires authentication can be
  updated ([#16](https://github.com/hjorslev/SteamPS/issues/16)).
- Update-SteamApp
  - Output ExitCode from SteamCMD if it has another value than 0 (success).

### Changed

- Improving structure / format of the code.
  - Remove sub-expressions where they are not needed.
- Dependencies are now handled in the module manifest instead of using custom
cmdlet `Use-Module`.
- Update-SteamServer
  - Fix minor issue with TimeoutLimit being hardcoded when writing to the log
  instead of using the value defined in the parameter `$TimeoutLimit`.
- Update tests to Pester 5. Thanks [Joel Sallow](https://github.com/vexx32/)!
  - ModuleValidation - general tests of the module.
  - Help - tests that each cmdlet uses Comment Based Help.

### Removed

- Remove private cmdlet Use-Module.

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
  parameter `AlwaysNotify` to always send notifications (fix [#3](https://github.com/hjorslev/SteamPS/issues/3)).

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
that requires administrator privileges (Install-SteamCMD, Update-SteamApp,
Update-SteamServer) allowing some cmdlets to be executed without administrator
privileges (Find-SteamAppID, Get-SteamServerInfo).
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
  - Remove check for version as it is done in SteamPS.psd1

## [1.0.0] - 01/01-2019

### Added

- Initial version
