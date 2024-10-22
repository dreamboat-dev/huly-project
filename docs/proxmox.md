# Proxmox

- [After Installation](#after-installation)
  - [Change Repos from Enterprise to Community Edition](#change-repos-from-enterprise-to-community-edition)
    - [`etc/apt/sources.list.d/pve-enterprise.list`](#etcaptsourceslistdpve-enterpriselist)
    - [`etc/apt/sources.list.d/ceph.list`](#etcaptsourceslistdcephlist)
  - [Network Config](#network-config)
    - [`/etc/network/interfaces`](#etcnetworkinterfaces)
    - [Start Network](#start-network)

<!-- 

## Installation

TODO (dreamboat-dev) initial installation 

-->

## After Installation

### Change Repos from Enterprise to Community Edition

#### `etc/apt/sources.list.d/pve-enterprise.list`

```bash
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
```

#### `etc/apt/sources.list.d/ceph.list`

```bash
deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription
```

### Network Config

#### `/etc/network/interfaces`

```bash
auto vmbr0
iface vmbr0 inet dhcp   # set interface to dhcp
    bridge-ports ens7f0 # bridge to physical interface
    bridge-stp off      # disable spanning tree
    bridge-fd 0         # no forwarding delay for bridge
```

#### Start Network

```bash
ifup vmbr0 # reload interface
```