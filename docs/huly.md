# Huly

- [Files](#files)
- [`docker-compose.yml`](#docker-composeyml)
  - [defaults](#defaults)
    - [`restart`](#restart)
    - [`env_file`](#env_file)
    - [`volumes`](#volumes)
    - [`networks`](#networks)
    - [`logging`](#logging)
      - [`driver`](#driver)
      - [`max-size`](#max-size)
      - [`max-file`](#max-file)
    - [`security_opt`](#security_opt)
  - [Required variables](#required-variables)
    - [Bind mounts](#bind-mounts)
      - [Data](#data)
      - [Logs](#logs)
      - [Nginx](#nginx)
    - [Authentication](#authentication)
    - [`SERVER_ADDRESS`](#server_address)
- [`directory-creation.sh`](#directory-creationsh)
  - [`directory-creation.cfg`](#directory-creationcfg)
    - [`DESIRED_LOG_LEVEL`](#desired_log_level)
    - [`LOG_FILE`](#log_file)
- [`default.conf`](#defaultconf)

---

## Files

- [huly](../huly/)
  - [docker-compose.yml](../huly/docker-compose.yml)
  - [.env](../huly/.env)
  - [default.conf (nginx)](../huly/default.conf)
- [scripts](../scripts/)
  - [directory-creation.sh](../scripts/directory-creation.sh)
  - [directory-creation.cfg](../scripts/config/directory-creation.cfg)

---

## [`docker-compose.yml`](../huly/docker-compose.yml)

> For more detailed documentation on every option see the official [docker-compose documentation](https://docs.docker.com/reference/compose-file/) or the documentation of a specific service.

### defaults

The defaults are applied to every container.

```yaml
x-defaults: &defaults
  restart: ${RESTART_POLICY:-unless-stopped}
  env_file:
    - "./.env"
  volumes:
    - /etc/timezone:/etc/timezone:ro
    - /etc/localtime:/etc/localtime:ro
  networks:
    - huly-internal-net
  logging:
    driver: ${LOGGING_DRIVER:-json-file}
    options:
      max-size: ${LOGGING_MAX_SIZE:-10m}
      max-file: ${LOGGING_MAX_FILE:-3}
  security_opt:
    - no-new-privileges:true
```

#### `restart`

Determines the restart policy of a container.

- **Variable:** `RESTART_POLICY`
- **Default:** `unless-stopped`

Accepted policies:  

- `no`: does not restart under any circumstances
- `always`: always restart until the container is removed
- `on-failure[:max-retries]`: restart the container if the exit code indicates an error. Optionally you can limit the number of retries
- `unless-stopped`: restart the container irrespective of the exit code, but stops restarting if the service has been stopped manually

#### `env_file`

Specifies the `.env`-file. In this file the environment variables are specified.

#### `volumes`

Bind the hosts timezone into the container.

- `/etc/timezone`: text-based representation of hosts timezone
- `/etc/localtime`: binary representation of rules used to calculate hosts time relative to unix time

#### `networks`

Every container is in the `huly-internal-net` by default.  
If it needs to be in the `huly-public-net` aswell, both have to be specified again under `services`.

#### `logging`

##### `driver`

Specifies the logging driver used.

- **Variable:** `LOGGING_DRIVER`
- **Default:** `json-file`

Accepted drivers:  

- `none`: no logs are stored
- `local`: logs are stored in a custom format designed for minimal overhead
- `json-file`: logs are formatted as JSON
- `syslog`: writes logs to the `syslog` facility
- `journald`: writes logs to `journald`
- `gelf`: writes logs to a Graylog Extended Log Format (GELF) endpoint such as Graylog or Logstash
- `fluentd`: writes logs to `fluentd`
- `awslogs`: writes logs to Amazon CLoudWatch
- `splunk`: writes logs to `splunk`
- `etwlogs`: writes logs as Event Tracing for Windows (ETW) events (only available on Windows)
- `gcplogs`: writes logs to Google Cloud Platform (GCP)

##### `max-size`

Specifies the max size of a log file.

- **Variable:** `LOGGING_MAX_SIZE`
- **Default:** `10m`

Available units:

- `k`: kilobyte
- `m`: megabyte
- `g`: gigabyte

##### `max-file`

Specifies the maximum number of log files for a service.

- **Variable:** `LOGGING_MAX_FILE`
- **Default:** `3`

#### `security_opt`

Setting `no-new-privileges:true` prevents privilege escalation.

### Required variables

If these variables aren't set, composing will throw an error.

#### Bind mounts

> These variables have default values assigned in the [`.env`-file](../huly/.env)

All variables for bind mounts on the local filesystem have to be set. These are:

##### Data

- `MONGODB_DATA_PATH`
- `ELASTIC_DATA_PATH`
- `MINIO_DATA_PATH`

##### Logs

- `ELASTIC_LOGS_PATH`
- `TRANSACTOR_LOGS_PATH`
- `COLLABORATOR_LOGS_PATH`
- `ACCOUNT_LOGS_PATH`
- `FRONT_LOGS_PATH`

##### Nginx

- `NGINX_CONF_PATH`

This must be the path of the Nginx `default.conf`.  
By default it is: `../huly/default.conf`.

#### Authentication

Variables for passwords and secrets have to be set. These are:

- `HULY_SECRET`
- `MONGODB_PASSWORD`
- `MINIO_ROOT_PASSWORD`

#### `SERVER_ADDRESS`

Address of the server huly is running on. This has to be set properly, else you won't be able to login.

---

## `directory-creation.sh`

This script reads the [`.env`-file](../huly/.env) and extracts the corresponding paths for the variables under the `=== VOLUMES ===` section.  

These directories are then created and given the correct ownership.

### `directory-creation.cfg`

Config file for [`directory-creation.sh`](../scripts/directory-creation.sh).

#### `DESIRED_LOG_LEVEL`

Specifies the desired log level for this script.  
By default it is set to `INFO`.

Accepted values:

- `DEBUG`
- `INFO`
- `WARN`
- `ERROR`
- `FATAL`

#### `LOG_FILE`

Specifies the full path of the log file.  
By default it is set to `/tmp/directory-creation.log`.

---

## [`default.conf`](../huly/default.conf)

This is the nginx config.  
It is only used to proxy to the different services.

> It is planned to be replaced with traefik.
