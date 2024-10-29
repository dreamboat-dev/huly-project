# Huly

## Files

- [`docker-compose.yml`](../huly/docker-compose.yml)
- [`.env`](../huly/.env)
- [`directory-creation.sh`](../scripts/directory-creation.sh)
  - [`directory-creation.cfg`](../scripts/config/directory-creation.cfg)

## Services

> All configuration is done in the `[.env](../huly/.env)`-File

- MongoDB
- Elasticsearch
- MinIO
- Rekoni
- Transactor
- Collaborator
- Account
- Workspace
- Front
- Nginx

## Purpose of Script

- get Variables from [`.env`](../huly/.env) for Volumes
- create the necessary directories
- give elastic-directories the correct permissions (UID: 1000)
- copy [nginx config](../huly/default.conf) into it's directory

### [`directory-creation.cfg`](../scripts/config/directory-creation.cfg)

#### `DESIRED_LOG_LEVEL` 

- indicates the log level of the script
- acceptable input: `DEBUG | INFO | WARN | ERROR | FATAL`

#### `LOG_FILE`

- full path for log file