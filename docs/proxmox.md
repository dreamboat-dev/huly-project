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

### "CPU with AVX support required"

> ```
> WARNING: MongoDB 5.0+ requires a CPU with AVX support, and your current system does not appear to have that!
>   see https://jira.mongodb.org/browse/SERVER-54407
>   see also https://www.mongodb.com/community/forums/t/mongodb-5-0-cpu-intel-g4650-compatibility/116610/2
>   see also https://github.com/docker-library/mongo/issues/485#issuecomment-891991814
> ```

This is caused by the VMs CPU not having direct access to the Hosts CPU.  
To fix this, the CPU type has to be changed to "host" in the proxmox hardware settings of the vm.  
After that shutdown the CPU (don't reboot! this won't work) and start again.