# Initial VM setup

We have set up two VMs:

- `debianmain`
  - will host a docker management service, the reverse proxy (traefik), authentication etc.  
- `debianhuly`
  - will host only huly and it's dependencies

<!-- TODO toc -->

## Resources

|              | `debianmain` | `debianhuly` |
| ------------ | :----------: | :----------: |
| **vCPUs:**   |      4       |      8       |
| **Storage:** |    32 GiB    |    96 GiB    |
| **RAM:**     |   8192 MiB   |  16384 MiB   |

## Installation

- **Language:**
  - Language: English
  - Keyboard: German
- **Hostname:**
  - `debianmain` | `debianhuly`
- **Users:**
  - **root password:** REDACTED -> see vaultwarden
  - **non-sudo user:** REDACTED -> see vaultwarden
  - **non-sudo password:** REDACTED -> see vaultwarden

### Partition

#### `debianmain`

| Name | Type    | Mountpoint |  Size | File System |
| ---- | ------- | ---------- | ----: | ----------- |
| boot | Boot    | `/boot`    |  2 GB | EXT4        |
| root | Primary | `/`        | 30 GB | EXT4        |
| swap | Primary |            |  2 GB |             |

#### `debianhuly`

| Name | Type    | Mountpoint |    Size | File System |
| ---- | ------- | ---------- | ------: | ----------- |
| boot | Boot    | `/boot`    |    2 GB | EXT4        |
| root | Primary | `/`        | 97.1 GB | EXT4        |
| swap | Primary |            |    4 GB |             |

### Packages

- [ ] Debian desktop environment
- [ ] ... GNOME
- [ ] ... Xfce
- [ ] ... GNOME Flashback
- [ ] ... KDE Plasma
- [ ] ... MATE
- [ ] ... LXDE
- [ ] ... LXQt
- [ ] web server
- [ ] SSH server
- [ ] standard system utilities

## After install

> For these steps you need to be logged in as root.

```bash
systemctl --failed    # view failed systemd services
journalctl -p 3 -xb   # view high priority errors in systemd journal
```
