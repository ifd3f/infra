# Network

This document describes my planned network layout for v4 of my homelab.

## Sites

Sites roughly correspond to physical locations, but they do not have to. They
are numbered with two hexadecimal digits. They are currently designated as
follows:

##### Site 00

The non-geographic site. Contains everything that isn't really associated with a
fixed geographic location. This may include VPNs, global IPs, and so forth.

##### Physical sites

| Number | Abbreviation | Description                                       |
| ------ | ------------ | ------------------------------------------------- |
| 01     | BRL0         | Burlingame, CA, at my home                        |
| 02     | SLO0         | San Luis Obispo, CA, at my apartment              |
| 03     | SLO1         | San Luis Obispo, CA, at my girlfriend's apartment |

## IP Addresses

**IPv6** is used for the majority of internal networking. This plan has been
inspired by the
[_Preparing an IPv6 Address Plan Manual_, by SurfNet](https://www.ripe.net/support/training/material/IPv6-for-LIRs-Training-Course/Preparing-an-IPv6-Addressing-Plan.pdf).

I will mostly be assigning `/128` addresses using stateful DHCPv6. However,
because Android
[does not and will not support stateful DHCPv6](https://issuetracker.google.com/issues/36949085?pli=1),
I will support SLAAC on networks for user devices.

**IPv4** will be used sparingly, mostly for compatibility with things that do
not support IPv6 yet. It will also be supported on networks for user devices.

### Subnetting plan

I have randomly chosen a
[Unique Local Address](https://en.wikipedia.org/wiki/Unique_local_address) space
with global ID **`531de8470a`**, making my full internal subnet
**fd53:1de8:470a::/48`**.

I have space for 256 **sites** designated by a hexadecimal number `LL`. Each
site thus has prefix **`fd53:1de8:470a:LL00:/56`**.

Each site may have up to 256 subnets designated by a hexadecimal number `BB`,
which may be allocated for any purpose needed. Thus, each of the 65536 subnets
is has prefix **`fd53:1de8:470a:LLBB:/64`**.

From now on, I will refer to a subnet under a site as `SLL-BB`.

#### `S00-00`

This subnet is extremely convenient because I can just write IPs under it as
`fd53:1de8:470a::<whatever>`, so it is reserved for global infrastructural IPs.

| CIDR                      | Description                             | Actual location |
| ------------------------- | --------------------------------------- | --------------- |
| `fd53:1de8:470a::5:1/128` | FreeIPA DC                              | S02             |
| `fd53:1de8:470a::69/128`  | Aggregate DNS server `dennis`, primary  | S02             |
| `fd53:1de8:470a::420/128` | Aggregate DNS server `snoop`, secondary | S02             |
| `fd53:1de8:470a::8:0/112` | Kubernetes-hosted services              | S02             |

#### VPNs and associated services

| CIDR                        | Description                                              |
| --------------------------- | -------------------------------------------------------- |
| `fd53:1de8:470a:2::/64`     | Internal ZeroTier network                                |
| `fd53:1de8:470a:2::/112`    | Internal ZeroTier network, DHCP range                    |
| `fd53:1de8:470a:11::/64`    | "Public" ZeroTier network                                |
| `fd53:1de8:470a:11::/112`   | "Public" ZeroTier network, DHCP range                    |
| `fd53:1de8:470a:11::27/128` | Reserved IP for `aliaconda` on "public" ZeroTier network |

#### Physical sites

To achieve greater compatibility, user-facing subnets will use SLAAC and
possibly allow IPv4.

| CIDR                         | Description                       |
| ---------------------------- | --------------------------------- |
| `fd53:1de8:470a:LL00::1/128` | Uplink router                     |
| `fd53:1de8:470a:LL00::5/128` | Backup jump server                |
| `fd53:1de8:470a:LL01::1/64`  | User-facing LAN, supporting SLAAC |
| `fd53:1de8:470a:LL01::1/128` | User-facing LAN, default gateway  |

#### S02-08

This is the Kubernetes cluster subnet. It is composed of a MAAS server,
virtualized node, and an array of bare-metal nodes.

The cluster on this subnet will communicate over IPv4, because it's
better-supported. Some devices may use IPv6 to translate to the outer world.

| IPv6                          | IPv4                | Description       |
| ----------------------------- | ------------------- | ----------------- |
| `fd53:1de8:470a:208::/64`     | `192.168.32.0/24`   | LAN               |
| `fd53:1de8:470a:208::1/128`   | `192.168.32.1/128`  | Uplink router/DNS |
| `fd53:1de8:470a:208::2/128`   | `192.168.32.2/128`  | MAAS server       |
| `fd53:1de8:470a:208:1:0-ffff` | `192.168.32.64-255` | DHCP range        |

## DNS - zones, nameservers, update policies...

### Public-facing (`*.astrid.tech`)

Everything public-facing is hosted by Cloudflare. With few exceptions, these
zones should be configured by the
[the Terraform Cloudflare project](../terraform/cloudflare).

### Sites (`s-**.astrid.tech`)

`s-LL.astrid.tech` will connect to the backup jump server at site `LL`. I'm
still unsure if I want to make it publicly accessible or not.

### LDAP Identity Domain (`*.id.astrid.tech`)

Its authoritative nameserver is the FreeIPA server. Domains under this will be
updated based on policies defined in FreeIPA.

### Strictly private services (`*.in.astrid.tech`)

This zone holds strictly private services (i.e. `nextcloud.in.astrid.tech`). I'm
still unsure if I should use Cloudflare, or PowerDNS as the authoritative
nameserver for it.

### Kubernetes services

Public- and private-facing Kubernetes services are updated by the
[external-dns operator](https://github.com/kubernetes-sigs/external-dns), which
is deployed in Kubernetes using a
[helm chart](../kubernetes/helmfile.d/dns.yaml).
