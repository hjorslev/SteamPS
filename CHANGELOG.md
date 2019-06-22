# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.1.3] - 01/03-2019

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