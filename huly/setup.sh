#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

main() {
    # path to .env file for docker-compose.yml
    local env_file="./.env"

    # if not root, exit the script
    if [[ "${EUID}" -ne 0 ]]; then
        echo "The script must be run as root!"
        exit 1
    fi

    # check if .env file exists
    if ! [[ -z "${env_file}"  ]]; then
        echo ".env file not found!"
        exit 1
    fi

    # root directory of huly volume
    local root_dir="/var/lib/docker/volumes/huly/_data"

    # create sub volume directories
    mkdir --parents "${root_dir}/${MONGODB_DATA_SUBVOLUME}"
    mkdir --parents "${root_dir}/${MONGODB_CONF_SUBVOLUME}"
    mkdir --parents "${root_dir}/${ELASTIC_DATA_SUBVOLUME}"
    mkdir --parents "${root_dir}/${ELASTIC_LOGS_SUBVOLUME}"
    mkdir --parents "${root_dir}/${MINIO_DATA_SUBVOLUME}"

    # change user permissions for sub volume directories
    chmod --recursive 755  "${root_dir}/${MONGODB_DATA_SUBVOLUME}"
    chmod --recursive 755  "${root_dir}/${MONGODB_CONF_SUBVOLUME}"
    chmod --recursive 755  "${root_dir}/${ELASTIC_DATA_SUBVOLUME}"
    chmod --recursive 755  "${root_dir}/${ELASTIC_LOGS_SUBVOLUME}"
    chmod --recursive 755  "${root_dir}/${MINIO_DATA_SUBVOLUME}"
}

main