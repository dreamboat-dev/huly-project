#!/usr/bin/env bash

set -eou pipefail

# Variable defining the environment file
readonly ENV_FILE=".env"

# Get "STORAGE_BASE_PATH" from .env file
base_dir="";
grep "STORAGE_BASE_PATH" "${ENV_FILE}" > .storage_base_path.env
while IFS="=" read -r key storage_base_path; do
    base_dir="${storage_base_path}"
done < .storage_base_path.env
rm -f .storage_base_path.env

# Set paths for services relative to base directory
elastic_path="${base_dir}/elastic"
mongodb_path="${base_dir}/mongodb"
minio_path="${base_dir}/minio"

# Create directories for each service
mkdir --parents "${elastic_path}"
mkdir --parents "${mongodb_path}"
mkdir --parents "${minio_path}"

# Set permissions for the directories
# so Elastic can access them
chmod g+rwx "${elastic_path}"
chgrp 0 "${elastic_path}"