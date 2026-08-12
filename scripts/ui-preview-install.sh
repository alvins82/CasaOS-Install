#!/usr/bin/env bash

set -euo pipefail

readonly RELEASE_TAG="v0.4.24"
readonly UI_ARCHIVE_URL="https://github.com/alvins82/CasaOS-UI/releases/download/${RELEASE_TAG}/linux-all-casaos-${RELEASE_TAG}.tar.gz"
readonly TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/casaos-ui-update.XXXXXX")"
readonly LOG_PATH="/var/log/casaos/upgrade.log"

cleanup() {
    rm -rf -- "${TMP_ROOT}"
}

trap cleanup EXIT

mkdir -p "$(dirname "${LOG_PATH}")"

log() {
    printf '%s\n' "$1" | tee -a "${LOG_PATH}"
}

log "Starting CasaOS UI update ${RELEASE_TAG}"
curl -fsSL --retry 3 --retry-delay 1 "${UI_ARCHIVE_URL}" -o "${TMP_ROOT}/ui.tar.gz"
tar -xzf "${TMP_ROOT}/ui.tar.gz" -C "${TMP_ROOT}"

if [[ ! -d "${TMP_ROOT}/build/sysroot/var/lib/casaos/www" ]]; then
    log "The UI archive did not contain the CasaOS web files"
    exit 1
fi

cp -a "${TMP_ROOT}/build/sysroot/." /
printf '%s\n' "${RELEASE_TAG}" > /var/lib/casaos/fork-release
systemctl restart casaos.service

log "CasaOS UI update ${RELEASE_TAG} completed"
