# K8s Jump Box Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- ## [UNRELEASED]
### Added
### Changed
### Deprecated
### Removed -->

## v1.3.1 - 2020-06-30

### Changed

- `redis-cli` version 6.2.4

## v1.3.0 - 2020-06-30

### Changed

- `redis-cli` now built from source with `BUILD_TLS=yes`

## v1.2.0 - 2020-06-02

### Added

- Add `openssl`

## v1.1.0 - 2020-04-16

### Added

- Add `curl`

## 1.0.3 - 2020-03-26

### Changed

- Actually update `stunnel-redis-cli` so `killall` does not expect process

## 1.0.2 - 2020-03-25

### Added

- Added packages `groff` and `less` for `aws help` to work

## 1.0.1 - 2020-03-24

### Changed

- Update `stunnel-redis-cli` so `killall` does not expect process

## 1.0.0 - 2020-03-24

### Added

- Initial Version
