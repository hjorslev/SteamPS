﻿# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/)
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.2.1] - 17/02-2019

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