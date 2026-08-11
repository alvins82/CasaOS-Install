#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly INSTALLER_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly WORKSPACE_ROOT="$(cd "${INSTALLER_ROOT}/.." && pwd)"
readonly APP_MANAGEMENT_ROOT="${APP_MANAGEMENT_ROOT:-${WORKSPACE_ROOT}/CasaOS-AppManagement}"
readonly COMPONENT_LOCK="${INSTALLER_ROOT}/release/ubuntu26-components.env"

# shellcheck source=../release/ubuntu26-components.env
source "${COMPONENT_LOCK}"

readonly BUNDLE_TAG="${CASAOS_BUNDLE_TAG}"
readonly APP_MANAGEMENT_VERSION="${CASAOS_APP_MANAGEMENT_VERSION}"
readonly OUTPUT_DIR="${1:-${INSTALLER_ROOT}/dist}"
readonly OVERLAY_FILE="linux-zz-casaos-ubuntu26-overlay-${BUNDLE_TAG}.tar.gz"

readonly APP_MANAGEMENT_COMMIT="$(git -C "${APP_MANAGEMENT_ROOT}" rev-parse HEAD)"
readonly BUILD_METADATA="${APP_MANAGEMENT_ROOT}/dist/metadata.json"

verify_repo_commit() {
    local repo_name="$1"
    local repo_path="$2"
    local expected_commit="$3"
    local actual_commit

    actual_commit="$(git -C "${repo_path}" rev-parse HEAD)"
    if [[ "${actual_commit}" != "${expected_commit}" ]]; then
        echo "${repo_name} is at ${actual_commit}; expected ${expected_commit}." >&2
        exit 1
    fi

    if ! git -C "${repo_path}" diff --quiet -- || ! git -C "${repo_path}" diff --cached --quiet --; then
        echo "${repo_name} has uncommitted tracked changes; refusing to package it." >&2
        exit 1
    fi
}

verify_repo_commit CasaOS-AppManagement "${APP_MANAGEMENT_ROOT}" "${CASAOS_APP_MANAGEMENT_COMMIT}"
verify_repo_commit CasaOS "${WORKSPACE_ROOT}/CasaOS" "${CASAOS_COMMIT}"
verify_repo_commit CasaOS-Gateway "${WORKSPACE_ROOT}/CasaOS-Gateway" "${CASAOS_GATEWAY_COMMIT}"
verify_repo_commit CasaOS-UserService "${WORKSPACE_ROOT}/CasaOS-UserService" "${CASAOS_USER_SERVICE_COMMIT}"
verify_repo_commit CasaOS-LocalStorage "${WORKSPACE_ROOT}/CasaOS-LocalStorage" "${CASAOS_LOCAL_STORAGE_COMMIT}"
verify_repo_commit CasaOS-MessageBus "${WORKSPACE_ROOT}/CasaOS-MessageBus" "${CASAOS_MESSAGE_BUS_COMMIT}"

if [[ ! -f "${BUILD_METADATA}" ]] || ! grep -q "\"commit\":\"${APP_MANAGEMENT_COMMIT}\"" "${BUILD_METADATA}"; then
    echo "AppManagement release artifacts do not match ${APP_MANAGEMENT_COMMIT}. Run a clean GoReleaser build first." >&2
    exit 1
fi

readonly STAGING_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/casaos-ubuntu26-bundle.XXXXXX")"
trap 'rm -rf "${STAGING_ROOT}"' EXIT

mkdir -p "${OUTPUT_DIR}"

create_archive() {
    local stage_dir="$1"
    local output_file="$2"

    find "${stage_dir}" -exec touch -t 202001010000 {} +
    COPYFILE_DISABLE=1 tar --format=ustar -C "${stage_dir}" -cf - build | gzip -n >"${output_file}"
}

package_app_management() {
    local target_arch="$1"
    local build_arch="$2"
    local app_build="$3"
    local converter_build="$4"
    local stage_dir="${STAGING_ROOT}/app-management-${target_arch}"
    local output_file="${OUTPUT_DIR}/linux-${target_arch}-casaos-app-management-${APP_MANAGEMENT_VERSION}.tar.gz"

    mkdir -p "${stage_dir}"
    cp -a "${APP_MANAGEMENT_ROOT}/build" "${stage_dir}/build"
    install -m 0755 \
        "${APP_MANAGEMENT_ROOT}/dist/${app_build}/build/sysroot/usr/bin/casaos-app-management" \
        "${stage_dir}/build/sysroot/usr/bin/casaos-app-management"
    install -m 0755 \
        "${APP_MANAGEMENT_ROOT}/dist/${converter_build}/build/sysroot/usr/bin/appfile2compose" \
        "${stage_dir}/build/sysroot/usr/bin/appfile2compose"

    create_archive "${stage_dir}" "${output_file}"
    echo "Packaged ${build_arch} AppManagement as $(basename "${output_file}")"
}

package_overlay() {
    local stage_dir="${STAGING_ROOT}/overlay"
    local setup_dir="${stage_dir}/build/scripts/setup/script.d"

    mkdir -p "${setup_dir}"
    install -m 0755 "${WORKSPACE_ROOT}/CasaOS-Gateway/build/scripts/setup/script.d/01-setup-gateway.sh" "${setup_dir}/"
    install -m 0755 "${WORKSPACE_ROOT}/CasaOS-UserService/build/scripts/setup/script.d/02-setup-user-service.sh" "${setup_dir}/"
    install -m 0755 "${WORKSPACE_ROOT}/CasaOS/build/scripts/setup/script.d/03-setup-casaos.sh" "${setup_dir}/"
    install -m 0755 "${WORKSPACE_ROOT}/CasaOS-LocalStorage/build/scripts/setup/script.d/04-setup-local-storage.sh" "${setup_dir}/"
    install -m 0755 "${WORKSPACE_ROOT}/CasaOS-MessageBus/build/scripts/setup/script.d/05-setup-message-bus.sh" "${setup_dir}/"
    install -m 0755 "${APP_MANAGEMENT_ROOT}/build/scripts/setup/script.d/06-setup-app-management.sh" "${setup_dir}/"

    create_archive "${stage_dir}" "${OUTPUT_DIR}/${OVERLAY_FILE}"
    echo "Packaged Ubuntu 26 setup overlay as ${OVERLAY_FILE}"
}

write_checksums() {
    local checksum_tool
    local asset
    local assets=(
        "linux-amd64-casaos-app-management-${APP_MANAGEMENT_VERSION}.tar.gz"
        "linux-arm64-casaos-app-management-${APP_MANAGEMENT_VERSION}.tar.gz"
        "linux-arm-7-casaos-app-management-${APP_MANAGEMENT_VERSION}.tar.gz"
        "${OVERLAY_FILE}"
        "install.sh"
        "components.lock"
    )

    if command -v sha256sum >/dev/null 2>&1; then
        checksum_tool=(sha256sum)
    else
        checksum_tool=(shasum -a 256)
    fi

    : >"${OUTPUT_DIR}/checksums.txt"
    for asset in "${assets[@]}"; do
        (
            cd "${OUTPUT_DIR}"
            "${checksum_tool[@]}" "${asset}"
        ) >>"${OUTPUT_DIR}/checksums.txt"
    done

    (
        cd "${OUTPUT_DIR}"
        "${checksum_tool[@]}" install.sh
    ) >"${OUTPUT_DIR}/install.sh.sha256"
}

package_app_management \
    amd64 \
    linux/amd64 \
    casaos-app-management-amd64_linux_amd64_v1 \
    casaos-app-management-appfile2compose-amd64_linux_amd64_v1
package_app_management \
    arm64 \
    linux/arm64 \
    casaos-app-management-arm64_linux_arm64 \
    casaos-app-management-appfile2compose-arm64_linux_arm64
package_app_management \
    arm-7 \
    linux/arm/v7 \
    casaos-app-management-arm-7_linux_arm_7 \
    casaos-app-management-appfile2compose-arm-7_linux_arm_7
package_overlay

install -m 0755 "${INSTALLER_ROOT}/install.sh" "${OUTPUT_DIR}/install.sh"
install -m 0644 "${COMPONENT_LOCK}" "${OUTPUT_DIR}/components.lock"
write_checksums

echo "Release bundle written to ${OUTPUT_DIR}"
