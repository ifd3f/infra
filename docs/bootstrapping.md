# Homelab Bootstrapping Sequence (WIP)

**DISCLAIMER:** This is a very vague general plan for bootstrapping. Everything is subject to change, and none of this has been proven to work in a real environment yet.

I could just manually set up my servers like I did before, but that's really boring. What's less boring is a fully-automated setup script!

## Inspiration

The setup order is inspired by the 1998 [_Bootstrapping an Infrastructure_](http://www.infrastructures.org/papers/bootstrap/bootstrap.html) paper by Traugott and Huddleston. Of course, this paper is literally older than I am, so I have given it a modern twist.

Traugott and Huddleston identify the bootstrap sequence as having the following steps, in approximately this order:

1. **Version Control -- CVS, track who made changes, backout.** We'll just let [Github](https://github.com/astralbijection/infrastructure) handle this step for us.
1. **Gold Server -- only require changes in one place.** This role is occupied by 2 machines. The first is the one-off Infra-Bootstrapper docker container, and the second is the more long-lasting Ansible Semaphore server.
1. **Host Install Tools -- install hosts without human intervention.** The Infra-Bootstrapper occupies this role.
1. **Ad Hoc Change Tools -- 'expect', to recover from early or big problems.** No need.
1. **Directory Servers -- DNS, NIS, LDAP.** Handled by FreeIPA.
1. **Authentication Servers -- NIS, Kerberos.** Handled by FreeIPA.
1. **Time Synchronization -- NTP.** I'll use an Ansible playbook to add NTP synchronization to an external pool.
1. **Network File Servers -- NFS, AFS, SMB.** TODO
1. **File Replication Servers -- SUP.** TODO
1. **Client File Access -- automount, AMD, autolink.** TODO
1. **Client OS Update -- rc.config, configure, make, cfengine.** This will be done by a periodic Ansible script.
1. **Client Configuration Management -- cfengine, SUP, CVSup.** Also done by a periodic Ansible script.
1. **Client Application Management -- autosup, autolink.** Most of our services will run in Kubernetes.
1. **Mail -- SMTP.** Lol no we aren't hosting mail
1. **Printing -- Linux/SMB to serve both NT and UNIX.** Printers? What's a printer?
1. **Monitoring -- syslogd, paging.** Configured by Ansible, pushed by Fluent bit, aggregated by Fluentd, Prometheus and Loki, and presented by Grafana.

## Manual Physical Infrastructure Setup

**Who does this?** A human.

Yeah, yeah, I promised it would be fully automated, but there are some limits to my power.

Automating the OS installs will likely require a medium amount of PXE fuckery. Automating the network wiring will be worse, because it will require an extremely large amount of robotics fuckery. So unfortunately, I will leave that to a future me.

### Wire the network

Following [this graph](./network.dot). (TODO include this as an image)

### Install operating systems

All bare-metal machines are to be installed with [Fedora Server 34](https://getfedora.org/en/server/download/).

## Kick-off the Process from a PC

**Who does this?** Your PC.

### Secret generation

TODO

### Infra-Bootstrapper 

In this step, we run an Ansible playbook to install Podman on a machine, then start a Infra-Bootstrapper (IBSR) container on it.

Simply execute:

```
ansible-playbook ansible/kickoff_bootstrap.yml
```

The rest of the process is fully automated from the Bootstrapper container using Ansible.
## Automated Base Infrastructure Setup

**Who does this?** The Infra-Bootstrapper.

TODO

### Set up LXD, Libvirt, and Podman on the bare metal machines
TODO

### Configure router/firewall

TODO

### Create the initial FreeIPA master server
TODO

### Create the initial HashiCorp Vault server
TODO

### Create the internal Continuous Deployment (CD) server

We will either use Jenkins or GitLab deployed in a LXC container. I don't know which one yet.

In theory, once this step works properly, all I have to do is `git push` to main and I can redeploy my entire stack!

## Continuous Infrastructure Deployment

**Who does this?** The CD server.

TODO

### Create a FreeIPA replica
TODO

### Create HashiCorp Vault replicas
TODO

### Set up storage and fileshares
TODO

### Set up databases
TODO

### Create Kubernetes cluster
TODO

### Continuous Kubernetes Deployment

TODO
