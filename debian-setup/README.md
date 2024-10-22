# Debian Setup

The main component of this is `setup.sh`.  
It is a script intended to be run upon the creation of a server.  
It configures `apt` repositories, `sshd` and installs some utilities (including docker).

- [Installation](#installation)
  - [Complete Repository](#complete-repository)
  - [Only huly subdirectory](#only-huly-subdirectory)
- [Usage](#usage)
  - [Config](#config)
- [Installed Packages](#installed-packages)

## Installation

### Complete Repository

```bash
git clone https://github.com/dreamboat-dev/huly-project.git
```

### Only huly subdirectory

```bash
git clone --no-checkout https://github.com/dreamboat-dev/huly-project.git
cd huly-project
git sparse-checkout init --cone
git sparse-checkout set debian-setup
git checkout
```

## Usage

> The script must be run as root!

```bash
sudo ./setup.sh
```

### Config

- **apt:** `apt/sources.list`
- **sshd:** `sshd/sshd_config`

## Installed Packages

- `docker`
- `plocate`
- `command-not-found`
- `openssh-server`
