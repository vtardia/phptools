# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.12] - 2025-02-22

### Fixed

 - Update legacy key/value format

## [1.1.11] - 2025-02-22

### Fixed

 - Remove leftover temp files

## [1.1.10] - 2024-04-13

### Fixed

 - Allow piping of standard input

## [1.1.9] - 2024-03-17

### Fixed

 - libyear binary is now available to install

### Added

 - Git and OpenSSH to allow Composer to install packages from remote repositories

## [1.1.8] - 2023-12-28

### Added

 - Using ZTS PHP
 - libyear utility

## [1.1.7] - 2023-10-19

### Added

- PECL AMQP extension

## [1.1.6] - 2023-08-31

### Fixed

- Disable port sharing when not used (for composer use `composer --server [...]`) to enable

## [1.1.5] - 2023-08-01

### Added

- PECL Redis extension to enable native session handler

## [1.1.4] - 2023-07-06

### Added

- Enable OPCache CLI for Composer and Psalm

## [1.1.3] - 2023-06-25

### Added

- OPCache extension
- PHPTools basic commands: shell and version
- Secured php.ini with OWASP settings (where sensible for development)
- Allow use of environment files with the `php` executable

## [1.1.2] - 2023-05-28

### Added

- MySQL PDO extension (`pdo_mysql`)
- Postgres PDO extension (`pdo_pgsql`)
- Process control extension (`pcntl`)

## [1.1.1] - 2023-03-10

### Added

- Zip extension

## [1.1.0] - 2023-01-07

### Added

- SQLite command
- This CHANGELOG file

### Changed

- Bumped PHP version to 8.2 and Xdebug to 3.2.0

### Fixed

- Fixed `~/bin` directory check within the install script

## [1.0.0] - 2022-12-03

### Added

- Initial commit for PHPTools v1.0.0 (PHP 8.1)
