# Debian - [`setup.sh`](../scripts/setup.sh)

> The script is only designed for use with Debian 12 Bookworm!  

## Purpose of Script

- Configure apt repositories [`sources.list`](../debian/sources.list)
- Install Docker
- Install utilities:
  - Plocate
  - Command-not-found
- Configure SSH [`sshd_config`](../debian/sshd_config)

## [`setup.cfg`](../scripts/config/setup.cfg)

### `DESIRED_LOG_LEVEL` 

- indicates the log level of the script
- acceptable input: `DEBUG | INFO | WARN | ERROR | FATAL`

### `LOG_FILE`

- full path for log file