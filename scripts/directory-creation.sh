#!/usr/bin/env bash
# shellcheck disable=SC2005,SC2155

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

main() {
    # source config
    source ./config/directory-creation.cfg
    # source logging framework
    source ./logging.sh

    # path to .env file for docker-compose.yml
    local env_file="../huly/.env"

    # identifiers for start and end of section
    local start_of_section="# === VOLUMES ============================================================================="
    local end_of_section="# ========================================================================================="

    # check if root, else exit
    if [[ "${EUID}" -ne 0 ]]; then
        log_error "This script must be run as root. Exiting"
        exit 1
    fi

    # check if .env file exists
    if ! [[ -e "${env_file}" ]]; then
        log_error: ".env file not found. Exiting"
        exit 1
    fi

    eval "$( \
        sed --quiet "/^${start_of_section}$/,/^${end_of_section}/p" ${env_file} | \
        grep --extended-regexp '^[A-Z_]+=' \
    )"

    local -a volumes=(
        "${MONGODB_DATA_PATH}"
        "${ELASTIC_DATA_PATH}"
        "${MINIO_DATA_PATH}"
        "${NGINX_CONF_PATH}"
        "${ELASTIC_LOGS_PATH}"
        "${TRANSACTOR_LOGS_PATH}"
        "${COLLABORATOR_LOGS_PATH}"
        "${ACCOUNT_LOGS_PATH}"
        "${WORKSPACE_LOGS_PATH}"
        "${FRONT_LOGS_PATH}"
    )

    for volume in "${volumes[@]}"; do
        mkdir --parents "${volume}"
    done
    chown 1000:0 "${ELASTIC_DATA_PATH}" \
                 "${ELASTIC_LOGS_PATH}"

    cp "../huly/default.conf" "${NGINX_CONF_PATH}"
}

main