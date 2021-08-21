# Homelab Bootstrapping Sequence (WIP)

**DISCLAIMER:** This is a very vague general plan for bootstrapping. Everything is subject to change, and none of this has been proven to work in a real environment yet.

I could just manually set up my servers like I did before, but that's really boring. What's less boring is a fully-automated setup script!

## Inspiration

### Setup Order

The setup order is inspired by the 1998 [_Bootstrapping an Infrastructure_](http://www.infrastructures.org/papers/bootstrap/bootstrap.html) paper by Traugott and Huddleston. Of course, this paper is literally older than I am, so I have given it a modern twist.

Here is how some of the major components that Traugott and Huddleston identify map onto my setup:

- **Version Control.** We'll just let [Github](https://github.com/astralbijection/infrastructure) handle this step for us.
- **Gold Server, Host Install Tools** This role is occupied by 2 machines. The first is the one-off Infra-Bootstrapper docker container, and the second is the more long-lasting Continuous Deployment (CD) server.
- **Directory Servers, Authentication Servers.** Handled by FreeIPA.
- **Time Synchronization.** I will use Ansible, pre-configuration in Packer images, and NixOS for this step.
- **Network File Servers, File Replication Servers.** TODO
- **Client OS Update, Client Configuration Management** This will be activated by the CD server, and performed by periodic Ansible scripts, maybe something in Kubernetes.
- **Monitoring** Configured by Ansible, pushed by Fluent bit, aggregated by Fluentd, Prometheus and Loki, and presented by Grafana.

### Separation of System and User Runtimes

RancherOS separates its Docker environments into [System Docker and a User Docker](https://rancher.com/docs/os/v1.x/en/#how-rancheros-works). I can do something similar, where I have a system-k8s cluster running critical stuff like FreeIPA and HashiCorp Vault, and a user-k8s cluster for running everything else.

In addition to those, I can also create a special, extra-hardened external-k8s cluster for public-facing apps that don't need a VPN to be accessed. This reduces my blast radius in case that gets hacked.

### Pets, Cattle, and Disposability

I want to try to have [cattle, not pets](https://devops.stackexchange.com/questions/653/what-is-the-definition-of-cattle-not-pets), because cattle are easier to configure and much more reliable. Unfortunately, I am nowhere near the scale where everything can be treated as cattle. For example, if I lose a physical machine, it would be catastrophic because I'm too poor to afford another one.

However, I can still try to push the cattle/pet boundary as far below the stack as possible by using as much declarative configuration management as possible:

|              Layer | "Cattleness" | Reason                                                               |
| -----------------: | ------------ | -------------------------------------------------------------------- |
|     App deployment | ⭐⭐⭐⭐⭐   | It's containerized, uses user-k8s                                    |
|     User-k8s Nodes | ⭐⭐⭐⭐⭐   | Can redeploy easily from CD                                          |
|    User-k8s Master | ⭐⭐⭐       | Won't be using HA, but can use NixOS to reproducibly configure.      |
|               LDAP | ⭐⭐⭐⭐     | LDAP is on FreeIPA, which is on system-k8s.                          |
|                DNS | ⭐⭐⭐⭐     | DNS is on FreeIPA, which is on system-k8s.                           |
| System-k8s Cluster | ⭐           | If it goes down, everything above it goes down.                      |
|                VMs | ⭐⭐⭐⭐     | Can be deployed and destroyed using Terraform, but there aren't many |
|      Bare-Metal OS | ⭐⭐⭐⭐     | Root wiped on every boot, but PXE still not set up                   |
|  Physical Machines | ⭐           | I'm poor                                                             |

## Manual Physical Infrastructure Setup

**Who does this?** A human.

Yeah, yeah, I promised it would be fully automated, but there are some limits to my power.

Automating the OS installs will likely require a medium amount of PXE fuckery. Automating the network wiring will be worse, because it will require an extremely large amount of robotics fuckery. So unfortunately, I will leave that to a future me.

### Wire the network

Following [this graph](./network.dot). (TODO include this as an image)

### Install operating systems

All bare-metal machines are to be installed with a customized [NixOS 21.05 ISO](https://github.com/astralbijection/infrastructure/tree/main/nixos/iso).

## Kick-off the Process from a PC

**Who does this?** Your PC.

### Secret generation

TODO

### Infra-Bootstrapper (???)

In this step, we run an Ansible playbook to install Podman on a machine, then start a Infra-Bootstrapper (IBSR) container on it.

Simply execute:

```
ansible-playbook ansible/kickoff_bootstrap.yml
```

The rest of the process is fully automated from the Bootstrapper container using Ansible.

## Automated Base Infrastructure Setup

**Who does this?** The Infra-Bootstrapper.

TODO

### Spawn system-k8s cluster

This is done by calling Terraform. Once it's created, we deploy our system-k8s configs to it.

This will create several very important services:

- FreeIPA
- Ansible Vault
- CD server. TODO: Will I use Jenkins? CDS?

### Configure router/firewall

We will need to update the router's DNS forwarding to point to our new FreeIPA nodes' IP.

## Continuous Infrastructure Deployment

**Who does this?** The CD server.

This is done continuously, on a regular basis or on git pushes.

### Set up storage and fileshares

TODO

### Set up databases

TODO

### Create user-k8s and external-k8s clusters

TODO
