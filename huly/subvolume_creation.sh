#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

main() {
    # path to .env file for docker-compose.yml
    local env_file="./.env"

    # start and end of volumes section in .env file
    local start_of_section="# === VOLUMES ============================================================================="
    local end_of_section="# ========================================================================================="

    # if not root, exit the script
    if [[ "${EUID}" -ne 0 ]]; then
        echo "The script must be run as root!"
        exit 1
    fi

    # check if .env file exists
    if ! [[ -e "${env_file}"  ]]; then
        echo ".env file not found!"
        exit 1
    fi

    eval "$( \
        sed --quiet "/^${start_of_section}$/,/^${end_of_section}/p" ${env_file} | \
        grep --extended-regexp '^[A-Z_]+=' \
    )"

    # root directory of huly volume
    local root_dir="/var/lib/docker/volumes/huly/_data"

    local -a subvolumes=(
        "${MONGODB_DATA_SUBVOLUME}"
        "${MONGODB_CONF_SUBVOLUME}"
        "${ELASTIC_DATA_SUBVOLUME}"
        "${ELASTIC_LOGS_SUBVOLUME}"
        "${MINIO_DATA_SUBVOLUME}"
    )

    for subvolume in "${subvolumes[@]}" ; do
        mkdir --parents "${root_dir}/${subvolume}"
        # 755:
        #   - 7: owner -> read, write, execute
        #   - 5: group -> read, execute
        #   - 5: other -> read, execute
        chmod --recursive 755 "${root_dir}/${subvolume}"
        # uid: 1000
        # gid: 1000
        chown --recursive 1000:1000 "${root_dir}/${subvolume}"
    done
}

main