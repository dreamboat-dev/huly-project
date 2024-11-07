# Proxmox

- [After Installation](#after-installation)
  - [Configure Repositories](#configure-repositories)
    - [Remove enterprise repos](#remove-enterprise-repos)
    - [Add community repos](#add-community-repos)
    - [Configure Debian repos](#configure-debian-repos)
    - [Update repos, packages and (if required) the system](#update-repos-packages-and-if-required-the-system)
  - [Network Config](#network-config)
- [CPU with AVX support](#cpu-with-avx-support)

<!-- 
TODO
## Installation
-->

## After Installation

### Configure Repositories

The repositories have to be configured, since by default the enterprise edition repositories are used.  
This needs to be changed so the free-tier ones are used instead.  
The downside of this is, that they aren't tested as thoroughly and thus could be unstable.

#### Remove enterprise repos

```bash
rm /etc/apt/sources.list.d/pve-enterprise.list  # enterprise repository for proxmox (requires subscription)
rm /etc/apt/sources.list.d/ceph.list            # ceph quincy repository (requires subscription)
```

#### Add community repos

The following commands will add the `no-subscription` repos for proxmox and Ceph Reef.  
We will use Ceph Reef instead of Ceph Quincy, since Reef is the newer version.

```bash
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list 
echo "deb http://download.proxmox.com/debian/ceph-reef bookworm no-subscription" > /etc/apt/sources.list.d/ceph-reef.list 
```

#### Configure Debian repos

```
cat << EOF > /etc/apt/sources.list
# === BOOKWORM
    deb http://deb.debian.org/debian/               bookworm            main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/               bookworm            main contrib non-free non-free-firmware

# === BOOKWORM SECURITY
    deb http://security.debian.org/debian-security  bookworm-security   main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security  bookworm-security   main contrib non-free non-free-firmware

# === BOOKWORM UPDATES
    deb http://deb.debian.org/debian/               bookworm-updates    main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/               bookworm-updates    main contrib non-free non-free-firmware

# === BOOKWORM BACKPORTS
    deb http://deb.debian.org/debian/               bookworm-backports  main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/               bookworm-backports  main contrib non-free non-free-firmware
EOF
```

#### Update repos, packages and (if required) the system

```bash
apt update && apt upgrade
apt dist-upgrade
```

### Network Config

We need to configure the network interface.  
Currently we are using DHCP, but this will be changed once the project goes into production.

```bash
auto lo
iface lo inet loopback

iface ens7f0 inet manual    # physical interface

auto vmbr0                  # virtual interface - dhcp
iface vmbr0 inet dhcp
    bridge-ports ens7f0     # bridge to physical interface
    bridge-stp off          # disable spanning tree
    bridge-fd 0             # no forwarding delay for bridge

#auto vmbr0                  # virtual interface - static ip
#iface vmbr0 inet static
#    address 192.168.0.2/24  # static ip with subnet
#    gateway 192.168.0.1     # gateway of the network
#    bridge-ports ens7f0     # bridge to physical interface
#    bridge-stp off          # disable spanning tree
#    bridge-fd 0             # no forwarding delay for bridge
```

To reload the network configuration enter the following command:

```bash
ifreload -a
```

## CPU with AVX support

For MongoDB our CPU needs to have AVX support.  
This isn't the case by default, because the Virtual CPU doesn't have access to the Hosts CPU.

We can fix this by changing the CPU-type to "host" in the Hardware Settings on the Proxmox Web Interface.  
After this the Host needs to be powered off and on again (don't just reboot, this won't work).
