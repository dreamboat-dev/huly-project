# VM-Setup

## Resources

- `debian-huly`
  - 96 GB Disk
  - 8 vCPUs
  - 16384 MiB RAM
  - 4 GB Swap

- `debian-main`
  - 32 GB Disk
  - 4 vCPUs
  - 8192 MiB RAM
  - 2 GB Swap

## System Installation

- Language:
  - Language: English
  - Keyboard: German
- Hostname: `debianhuly` / `debianmain`
- Users:
  - Root Password: REDACTED -> vaultwarden
  - non-sudo User: REDACTED -> vaultwarden
  - non-sudo password: REDACTED -> vaultwarden

| Name | Type    | Mountpoint | Size            | File System |
| ---- | ------- | ---------- | --------------- | ----------- |
| boot | Boot    | `/boot`    | 2 GB            | EXT4        |
| Root | Primary | `/`        | 97.1 GB / 28 GB | EXT4        |
| Swap | Primary |            | 4 GB / 2 GB     |             |

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
- [x] SSH server
- [x] standard system utilities

---

## After Install

```bash
# login as root

systemctl --failed # view failed systemd services
journalctl -p 3 -xb # view high priority errors in systemd journal
```

### Setup Script

```bash
git clone https://github.com/dreamboat-dev/huly-project.git
cd huly-project/debian-setup
./setup.sh
```