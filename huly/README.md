# Huly - Docker

<!-- TODO update -->

This is a docker-compose stack for the project management tool "[Huly](https://huly.io/)".  
It includes Nginx Webserver.

- [Installation](#installation)
  - [Complete Repository](#complete-repository)
  - [Only `huly` subdirectory](#only-huly-subdirectory)
- [Usage](#usage)
- [Documentation](#documentation)
  - [`subvolume_creation.sh`](#subvolume_creationsh)
  - [Environment Variables](#environment-variables)
  - [Default Settings (`x-defaults`)](#default-settings-x-defaults)
  - [`nginx.conf`](#nginxconf)

## Installation

### Complete Repository

```bash
git clone https://github.com/dreamboat-dev/huly-project.git
```

### Only `huly` subdirectory

```bash
git clone --no-checkout https://github.com/dreamboat-dev/huly-project.git
cd huly-project
git sparse-checkout init --cone
git sparse-checkout set huly
git checkout
```

## Usage

1. Configure `.env`-File
   - If hostnames have been changed, you have to adjust them in `nginx.conf`
1. Execute `subvolume_creation.sh`
1. `docker compose up -d`

---

## Documentation

### `subvolume_creation.sh`

The script must be run as root.  
It creates the paths to the directories of the subvolumes.  

The location of the `.env`-File is set at the top (`local env_file="./.env"`).

The Variables in the `=== VOLUMES ===` section are read into the script.  
Because of this you need to configure your `.env`-File before executing this script.

### Environment Variables

All configuration is done through environment variables.  
Most have default values (`${VAR:-value}`) but some are required (`${VAR:?}`).  

### Default Settings (`docker-compose.yml` > `x-defaults`)

The `&defaults` anchor defines default settings that are used across all services. These settings are:
- **Restart Policy:** Defaults to `unless-stopped`, can be configured with `${RESTART_POLICY}`
- **Environment File:** All services share the same `.env` file. This is done so it is compatible with portainer (`stack.env`)
- **Timezone:** `timezone` and `localtime` are mounted as read-only into every container.
  - `timezone`: text-based representation of hosts timezone
  - `localtime`: binary representation of rules used to calculate hosts time relative to unix time
- **Networks:** All containers are in the `huly-internal-net` by default
- **Logging:** The default logging driver is `json-file` but can be changed using `${LOGGING_DRIVER}`. Log file size and retentionb can be configured with `${LOGGING_MAX_SIZE}` and `${LOGGING_MAX_FILE}`

### `nginx.conf`

> Make sure that the hostnames provided in `.env` are consistent with the ones in `nginx.conf`!
