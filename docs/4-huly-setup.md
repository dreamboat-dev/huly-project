# Huly Setup

## CLI

### Cloning Repo

```bash
sudo mkdir --parents /opt/docker/huly \
  && sudo chown -R fi-admin:fi-admin /opt/docker/huly \
  && cd /opt/docker/huly \
  && git clone -b v2 https://github.com/dreamboat-dev/huly-project .
```

### Deploy

> Before deploying, ensure that all environment variables are set correctly!
{.is-info}

First you have to create the volume directories:

```bash
sudo ./directory-creation.sh
```

Now the stack can be started:

```bash
sudo docker compose -f /opt/docker/huly/docker-compose.yml up -d
```

## Web-Interface

### Admin User

- **First name:** `FI`
- **Last name:** `Admin`
- **Email:** `fi-support@sanktelisabeth.de`
- **Password:** `Vaultwarden > Huly: "FI Admin" User`

### Workspace

- **Workspace name:** `FI-Ausbildung`