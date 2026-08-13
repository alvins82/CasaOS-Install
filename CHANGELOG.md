# Changelog

All notable changes to the CasaOS fork installer are documented here.

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
