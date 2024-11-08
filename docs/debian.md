# Debian

- [`setup.cfg`](#setupcfg)
  - [`DESIRED_LOG_LEVEL`](#desired_log_level)
  - [`LOG_FILE`](#log_file)
- [non-sudo user prompt](#non-sudo-user-prompt)
- [`sources.list`](#sourceslist)
  - [structure](#structure)
  - [archive-type](#archive-type)
  - [repository-url](#repository-url)
  - [distribution](#distribution)
  - [component](#component)
- [Install Utilities](#install-utilities)
  - [`ca-certificates`](#ca-certificates)
  - [`curl`](#curl)
  - [`plocate`](#plocate)
  - [`command-not-found`](#command-not-found)
  - [`openssh-server`](#openssh-server)
- [Install Docker](#install-docker)
- [Setup SSH](#setup-ssh)
  - [`sshd_config`](#sshd_config)
    - [`Include`](#include)
    - [`Port`](#port)
    - [Authentication](#authentication)
      - [`LoginGraceTime`](#logingracetime)
      - [`PermitRootLogin`](#permitrootlogin)
      - [`StrictModes`](#strictmodes)
      - [`MaxAuthTries`](#maxauthtries)
      - [`MaxSessions`](#maxsessions)
      - [`PubkeyAuthentication`](#pubkeyauthentication)
      - [`AuthorizedKeysFile`](#authorizedkeysfile)
      - [`PasswordAuthentication`](#passwordauthentication)
      - [`PermitEmptyPasswords`](#permitemptypasswords)
      - [`KbdInteractiveAuthentication`](#kbdinteractiveauthentication)
      - [`UsePAM`](#usepam)

---

> The script can only be run:
>
> - as root
> - on Debian 12 Bookworm

## [`setup.cfg`](../scripts/config/setup.cfg)

This is the config file for the script.  

### `DESIRED_LOG_LEVEL`

Specifies the desired log level for this script.  
By default it is set to `INFO`.

Accepted values:

- `DEBUG`
- `INFO`
- `WARN`
- `ERROR`
- `FATAL`

### `LOG_FILE`

Specifies the full path of the log file.  
By default it is set to `/tmp/init.log`.

## non-sudo user prompt

The script prompts for the username of the desired non-sudo user.  
This user will be used for the ssh connection.

It validates this name, by only allowing:

- lowercase letters
- uppercase letters
- numbers
- underscores

After this validation it checks if the user exists, if not it throws an error.

---

## `sources.list`

The next step is backing up `/etc/apt/sources.list` to `/etc/apt/sources.list.bak`.  
This file indicates the repositories `apt` can use.

After this it copies [sources.list](../debian/sources.list) from this repository.

### structure

```
         [archive-type]    [repository-url]                 [distribution]    [component]
example: deb               http://deb.debian.org/debian/    bookworm          main contrib non-free non-free-firmware
```

### archive-type

- **deb:** binary packages
- **deb-src:** source code of packages

### repository-url

- url for the repository

### distribution

- **bookworm:** main repository
- **bookworm-security:** security updates
- **bookworm-updates:** general updates
- **bookworm-backports:** more up-to-date packages from "testing" branch

### component

- **main:** DFSG (Debian Free Software Guidelines) compatible packages
- **contrib:** DFSG compatible packages with non-free dependencies
- **non-free(-firmware):** non-free packages (not DFSG compatible software)

---

## Install Utilities

Different utilities that are used in the script or provide general improvments to the user-experience are installed here.  
These are:

### `ca-certificates`

> Essential for [Docker Installation](#install-docker)

Contains the certificate authorities shipped with Mozilla's browser to allow SSL-based applications to check for the authenticity of SSL connections

### `curl`

> Essential for [Docker Installation](#install-docker)

CLI tool for transferring data with URL syntax.

### `plocate`

> Not essential for the script to work

Utility for search the local filesystem.  
Gives much faster search results than `find` or `locate`.

### `command-not-found`

> Not essential for the script to work

If a command is not available, this will look up available repositories and recommend the installation of the corresponding package.

### `openssh-server`

> Essential for [Setup SSH](#setup-ssh)

Portable version of OpenSSH.  
Provides the sshd server.

---

## Install Docker

First any conflicting packages are removed:

- `docker.io`
- `docker-doc`
- `docker-compose`
- `podman-docker`
- `containerd`
- `runc`

Next the Docker GPG key is added.  

After this `/etc/apt/sources.list.d/docker.list` is created and the docker repository is echoed into it.

The last step is the installation of the necessary docker packes:

- `docker-ce`
- `docker-ce-cli`
- `containerd.io`
- `docker-buildx-plugin`
- `docker-compose-plugin`

---

## Setup SSH

At first the ssh directory and `authorized_keys` file are created in the non-sudo users home directory, if they don't already exist.
These are give the corresponding permissions (dir: `700` and file: `600`) and ownership is given to the non-sudo user.

The next step is backing up `/etc/ssh/sshd_config` to `/etc/ssh/sshd_config.bak`.  
This file indicates the config for sshd.

After this it copies [sshd_config](../debian/sshd_config) from this repository.

The last step is a validation of `sshd_config`.  
If the config isn't valid, it will be replaced by the backup of the original config. The script will throw an error and exit.

### `sshd_config`

> [man page](https://man7.org/linux/man-pages/man5/sshd_config.5.html)

#### `Include`

Include the specified configuration file(s).  
Multiple pathnames may be specified and each pathname may contain wildcards.

#### `Port`

Specified the port number that sshd listens on.  
The Multiple options are permitted.

#### Authentication

##### `LoginGraceTime`

The server disconnects after this time if the user has not successfully logged in.  
If the value is 0, there is no time limit.

##### `PermitRootLogin`

Specifies whether root can log in using ssh.  
The argument must be:

- `yes` (root login is permitted)
- `prohibit-password` (password and keyboard-interactive authentication disabled)
- `forced-commands-only` (root login with a key is allowed, but only if the `command` option has been specified)
- `no` (no root login is permitted)

> Recommendation: `no`
>
> The root user is a common attack surface.  
> If it isn't permitted to login with ssh, the attacker has to guess the username of a permitted user which is much more unlikely.

##### `StrictModes`

Specifies whether sshd should check file modes and ownership of the user's files and home directory before accepting login. This is normally desirable because novices sometimes accidentally leave their directory or files world-writable.

##### `MaxAuthTries`

Specified the maximum number of authentication attempts permitted per connection. Once the number of failures reaches half this value, additional failures are logged.

##### `MaxSessions`

Specified the maximum number of open shell, login or subsystem sessions permitted per network connection.

##### `PubkeyAuthentication`

> Recommendation: `yes`
>
> For security reasons it is always recommended to use a key instead of a password.

Specifies whether public key authentication is allowed.

##### `AuthorizedKeysFile`

Specifies the file that contains the public keys used for user authentication. After expansion this is taken to be an absolute path  or one relative to the user's home directory. Multiple files may be listed, separated by whitespace.

##### `PasswordAuthentication`

> Recommendation: `no`
>
> For security reasons it is recommend to disallow authentication by password,
> since this can be much more easily guessed than a key.

Specifies whether password authentication is allowed.

##### `PermitEmptyPasswords`

When password authentication is allowed, it specifies whether the server allows login to accounts with empty password strings.

##### `KbdInteractiveAuthentication`

Specifies whether to allow `keyboard-interactive` authentication. All authentication styles from [login.conf(5)](https://man.openbsd.org/login.conf.5) are supported.

##### `UsePAM`

Enables the "Pluggable Authentication Module" interface.  

Because PAM keyboard-interactive authentication usually serves an equivalent role to password authentication, you should disable either `PasswordAuthentication` or `KbdInteractiveAuthentication`.
