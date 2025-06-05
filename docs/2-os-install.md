# OS Install

## Language

- **Language:** `English`
- **Location:** `Germany`
- **Locale:** `en_US.UTF-8`
- **Keymap:** `Germany`

## Networking

- **Hostname:** `lnx-huly-01`
- **Domain name:** none

## Users

- **Root Password:** none
- **Non-Root username:** `fi-admin`
- **Non-Root password:** `Vaultwarden > 3050: DEV-LNX-Huly-01`

## Partitioning

| ID  |    Size | Bootable? | Type | Mount Point | Notes                |
| :-: | ------: | :-------: | ---- | ----------- | -------------------- |
| #1  |    1 GB |    yes    | ESP  |             | EFI System Partition |
| #3  | 63.7 GB |    no     | ext4 | `/`         | Root Partition       |
| #2  |  4.0 GB |    no     | swap | swap        | Swap Partition       |

## Package Manager

@B5N2@xbg%M5#37x2#!P!EyGSQNM8*RJ

- **Debian archive mirror:** `deb.debian.org`

## Packages

- [ ] Debian desktop environment
- [ ] ... GNOME
- [ ] ... Xfce
- [ ] ... GNOME Flashback
- [ ] ... KDE Plasma
- [ ] ... Cinnamon
- [ ] ... MATE
- [ ] ... LXDE
- [ ] ... LXQt
- [ ] web server
- [ ] SSH server
- [x] standard system utilities
