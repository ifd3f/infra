# Network

## DNS

There are 2 primary DNS servers I use. Cloudflare exposes my external services, and FreeIPA exposes my internal services.

### Where do DNS records come from?

**Static records that generally shouldn't change** are created by Terraform. Public ones are in the [Cloudflare project](../terraform/cloudflare). 

_Examples: email records, external hosting like Vercel or Github Pages. For a complete list, see those configs._

**Kubernetes services** are created by the [external-dns operator](https://github.com/kubernetes-sigs/external-dns). It is deployed in Kubernetes using a [helm chart](../kubernetes/helmfile.d/dns.yaml).

### Zones

| Zone             | Purpose                                         |
| ---------------- | ----------------------------------------------- |
| `s.astrid.tech`  | Private services (the s stands for service)     |
| `id.astrid.tech` | LDAP identity domain, as well as internal hosts |
| `h.astrid.tech`  | Public-facing hosts (the h stands for host)     |

## IPv4

| Subnet           | Purpose                                                                                                             |
| ---------------- | ------------------------------------------------------------------------------------------------------------------- |
| `192.168.8.0/24` | "Internal" home IP range. There is a router between the "internal" and "external" services to create this division. |
| `192.168.1.0/24` | "External" home IP range, so that I don't fuck up my mom's internet service while doing things.                     |
| `192.168.9.0/24` | Planned travel VPN IP range.                                                                                        |

| IP            | Host                         | Purpose                         |
| ------------- | ---------------------------- | ------------------------------- |
| `192.168.8.1` | `home0-router.p.astrid.tech` | Primary router, and DHCP server |
| `192.168.8.8` | `ipa0.id.astrid.tech`        | FreeIPA server and DNS          |
