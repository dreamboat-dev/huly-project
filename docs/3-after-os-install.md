# After OS Install

## `apt` Repositiories

```bash
sudo nano /etc/apt/sources.list
```

```bash
# === BOOKWORM
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware

# === BOOKWORM SECURITY
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

# === BOOKWORM UPDATES
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware

# === BOOKWORM BACKPORTS
deb http://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware
```

```bash
sudo apt update
```

## SSH Setup

```bash
sudo apt install openssh-server
```

Set the following in `/etc/ssh/sshd_config`

```
Port 22
PasswordAuthentication yes
```

Now restart the sshd service:

```bash
sudo sytemctl restart sshd.service
```

## Docker Installation

```bash
sudo apt remove docker.io docker-doc docker-compose podman-docker containerd runc \
  && sudo apt update \
  && sudo apt install ca-certificates curl \
  && sudo install -m 0755 -d /etc/apt/keyrings \
  && sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
  && sudo chmod a+r /etc/apt/keyrings/docker.asc \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"${VERSION_CODENAME}\") stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && sudo apt update \
  && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```