# Traefik

Traefik is a reverse proxy.  
It can be configured dynamically (inside `docker-compose.yml`) or in static configs (`traefik.yml` & `fileConfig.yml`)

## Files

- [`docker-compose.yml`](../traefik/docker-compose.yml)
- [`.env`](../traefik/.env)

> All configuration is done in the `[.env](../traefik/.env)`-File

## Environment Variables

### Container and Container Behaviour

#### `IMAGE_TAG`

- tag (version) of the docker images

#### `CONTAINER_NAME`

- Display name of the container

#### `HOSTNAME`

- Hostname of the container

#### `RESTART_POLICY`

- Behaviour of the container if it is stopped

### Networking

#### `TRAEFIK_NET`

- Name of the traefik network

#### `TRAEFIK_PORT`

- Exposed Port for Traefik Instance

#### `DASHBOARD_PORT`

- Exposed Port for Traefik Dashboard

### Files

#### `TRAEFIK_PATH`

- Path to the Traefik directory

#### `TRAEFIK_FILECONFIG_YML_PATH`

- Path to `fileConfig.yml` on host

#### `TRAEFIK_TRAEFIK_YML_PATH`

- Path to `traefik.yml` on host