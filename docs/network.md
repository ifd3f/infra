# Network

## DNS

See the [Cloudflare Terraform configs](https://github.com/astralbijection/infrastructure/tree/main/terraform/cloudflare) for a complete list of public DNS entries.

| Zone            | Purpose                                                                    |
| --------------- | -------------------------------------------------------------------------- |
| `s.astrid.tech` | Private services (the s stands for service)                                |
| `p.astrid.tech` | LDAP identity domain, as well as internal hosts (the p stands for private) |
| `h.astrid.tech` | Public-facing hosts (the h stands for host)                                |

## IPv4

| Subnet           | Purpose                                                                                                             |
| ---------------- | ------------------------------------------------------------------------------------------------------------------- |
| `192.168.8.0/24` | "Internal" home IP range. There is a router between the "internal" and "external" services to create this division. |
| `192.168.1.0/24` | "External" home IP range, so that I don't fuck up my mom's internet service while doing things.                     |
| `192.168.9.0/24` | Planned travel VPN IP range.                                                                                        |

| IP            | Host                         | Purpose                         |
| ------------- | ---------------------------- | ------------------------------- |
| `192.168.8.1` | `home0-router.p.astrid.tech` | Primary router, and DHCP server |
| `192.168.8.8` | `ipa0.p.astrid.tech`         | FreeIPA server and DNS          |
