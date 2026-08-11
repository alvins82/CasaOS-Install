# CasaOS Installer

This fork preserves the normal CasaOS installer behavior for supported Linux systems while adding the Docker compatibility and Ubuntu 26 `resolute` fixes from the CasaOS component forks. Ubuntu 26 is supported; it is not required.

## Install

`install.sh` is the only supported installer entrypoint in this repository.

Install the latest stable release through an OS-neutral URL with one command:

```bash
curl -fsSL https://github.com/alvins82/CasaOS-Install/releases/latest/download/install.sh | sudo bash
```

This installs the full fork release, including all Docker compatibility fixes.

Supported installer architectures are amd64, arm64, and arm/v7.

## What is included

- Docker/Compose SDK upgrades and API negotiation in [CasaOS-AppManagement](https://github.com/alvins82/CasaOS-AppManagement)
- Ubuntu 26 setup resolution in [CasaOS](https://github.com/alvins82/CasaOS), [Gateway](https://github.com/alvins82/CasaOS-Gateway), [UserService](https://github.com/alvins82/CasaOS-UserService), [LocalStorage](https://github.com/alvins82/CasaOS-LocalStorage), and [MessageBus](https://github.com/alvins82/CasaOS-MessageBus)
- SHA-256 verification of every fork-owned package before extraction
- A release `components.lock` file recording the exact source commit for every patched component

The upstream project is [IceWhaleTech/CasaOS](https://github.com/IceWhaleTech/CasaOS). This distribution is maintained independently until the compatibility changes are available upstream.
