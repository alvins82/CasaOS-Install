# Changelog

All notable changes to the CasaOS fork installer are documented here.

## [0.4.32] - 2026-08-14

### Fixed

- Pin CasaOS LocalStorage `v0.4.25`, which restores persisted mergerfs mounts before creating default `/DATA` directories so upgrades and service restarts retain the configured merged storage ([CasaOS-LocalStorage #9](https://github.com/alvins82/CasaOS-LocalStorage/pull/9)).

### Changed

- Keep the CasaOS core, UI, and other component commits from `v0.4.31` while updating the LocalStorage component lock to merge commit `837e73d9383ffaa585bcf11ef1367d7b8440cfcc`.

### Verification

- Rebuilt the platform-neutral amd64, arm64, and arm/v7 installer bundle.
- Preserved SHA-256 verification for all fork-owned installer assets.

## [0.4.31] - 2026-08-14

### Added

- Publish a platform-neutral amd64, arm64, and arm/v7 bundle containing CasaOS core `v0.4.27` with host-level SMB zeroconf discovery through mDNS/DNS-SD and Windows Web Service Discovery.
- Install Avahi and wsdd opportunistically so discovery remains enabled by default where the distribution provides the packages without making installation or upgrades fail when it does not.

### Changed

- Pin CasaOS core commit `723bc2238447aee2b00e97dc15373a35f5ca7381` and tag `v0.4.27` in the component lock.
- Keep CasaOS UI `v0.4.29`, LocalStorage `v0.4.24`, and the unchanged component commits from `v0.4.30`.

### Fixed

- Configure only the mDNS and WS-Discovery firewall ports required for LAN discovery, without enabling SMB1 or legacy NetBIOS ports.

## [0.4.30] - 2026-08-13

### Added

- Publish the next platform-neutral amd64, arm64, and arm/v7 bundle with the merged-storage default-directory fix.

### Changed

- Pin CasaOS core `v0.4.26`, CasaOS UI `v0.4.29`, and CasaOS LocalStorage `v0.4.24` in the component lock.
- Keep the unchanged Gateway, UserService, MessageBus, AppManagement, CLI, and AppStore component commits from `v0.4.29`.

### Fixed

- Create missing `Documents`, `Downloads`, `Gallery`, and `Media` directories when external merged storage is created, while preserving system `AppData` behavior ([CasaOS-LocalStorage #7](https://github.com/alvins82/CasaOS-LocalStorage/pull/7)).

## [0.4.29] - 2026-08-13

### Added

- Publish a platform-neutral amd64, arm64, and arm/v7 bundle containing the latest CasaOS, UI, and LocalStorage releases.
- Add Files dialog, single-surface dashboard scrolling, corrected hidden-files icons, and storage-volume rename controls to the bundled user experience ([CasaOS #21](https://github.com/alvins82/CasaOS/pull/21); [CasaOS-UI #11](https://github.com/alvins82/CasaOS-UI/pull/11); [CasaOS-UI #12](https://github.com/alvins82/CasaOS-UI/pull/12); [CasaOS-UI #13](https://github.com/alvins82/CasaOS-UI/pull/13); [CasaOS-UI #14](https://github.com/alvins82/CasaOS-UI/pull/14)).

### Changed

- Pin CasaOS core `v0.4.26`, CasaOS UI `v0.4.29`, and CasaOS LocalStorage `v0.4.23` in the component lock.
- Keep the exact merged component commits for the release in the component metadata.

### Fixed

- Add protected storage-volume renaming and immediate filesystem-label refresh after a successful rename ([CasaOS-LocalStorage #6](https://github.com/alvins82/CasaOS-LocalStorage/pull/6)).

## [0.4.26] - 2026-08-13

### Added

- Publish a platform-neutral amd64, arm64, and arm/v7 bundle containing the merged CasaOS, UI, and LocalStorage updates.

### Changed

- Pin CasaOS core `v0.4.25`, CasaOS UI `v0.4.28`, and CasaOS LocalStorage `v0.4.22` in the component lock.
- Keep the exact component commits for CasaOS #20, CasaOS-UI #8–#10, and CasaOS-LocalStorage #5 in the release metadata.

### Fixed

- Ship in-dashboard system package updates with the backend terminal-state reconciliation fix ([CasaOS #20](https://github.com/alvins82/CasaOS/pull/20); [CasaOS-UI #10](https://github.com/alvins82/CasaOS-UI/pull/10)).
- Report accurate nested filesystem usage and disk ownership in Storage Manager ([CasaOS-LocalStorage #5](https://github.com/alvins82/CasaOS-LocalStorage/pull/5); [CasaOS-UI #9](https://github.com/alvins82/CasaOS-UI/pull/9)).
- Add the persistent widget search toggle and remove the sidebar clipping scrollbar ([CasaOS-UI #8](https://github.com/alvins82/CasaOS-UI/pull/8)).

## [0.4.25] - 2026-08-12

### Changed

- Pin CasaOS LocalStorage `v0.4.21`, which excludes system storage from merged `/DATA` branches.
- Pin CasaOS UI `v0.4.27`, which labels system storage as excluded and keeps system AppData available at `/DATA/AppData`.
- Publish a complete platform-neutral installer bundle for amd64, arm64, and arm/v7.

### Fixed

- Preserve the existing system data tree while moving `/DATA` onto external mergerfs storage.
- Keep the fork release marker and update manifest aligned so the CasaOS dashboard can discover and apply this release.

## [0.4.22] - 2026-08-12

### Changed

- Pin CasaOS UI `v0.4.26` for the qBittorrent top-level launch behavior.
