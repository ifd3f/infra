# Cluster Bootstrapping Routine

Inspired by the 1998 [_Bootstrapping an Infrastructure_](http://www.infrastructures.org/papers/bootstrap/bootstrap.html) paper, with a modern twist.

I could just manually set up my servers like I did before, but that's really boring. This folder contains scripts for (eventually) fully-automated setup!

## Manual Physical Infrastructure Setup

This unfortunately has not yet been automated; doing so is likely to be difficult and require some PXE fuckery. After this step, though, the bootstrap sequence is fully automatic.

### Wire the network

### Install operating systems 

- Bongus, a HP DL380P Gen8 server, gets Debian.
- One machine gets Fedora, and it will be the FreeIPA controller.
- The rest get Debian.

## Automated Critical Infrastructure Setup

### Set up Bongus as a hypervisor

### Create an in-firewall ops server

This operations server will continue the rest of the bootstrapping process. It needs access to the internal network, which is why it's on Bongus. Once this step is completed, the boostrapping machine is free to step away.

### Create a HashiCorp Vault server

### Create a firewall/routing server 

This step is critical for making sure that all the machines behind Bongus can actually get internet. This server will either run on PFSense, or as a BSD node with nftables.

### Set up the Domain Controller master

### Configure Proxmox to authenticate with LDAP

## Automated Secondary Infrastructure Setup

Once all those previous steps have been cleared, the rest of the steps are fairly easy to do.

### Set up a Domain Controller replica

### Set up storage and fileshares

### Cluster Bongus with the other designated hypervisors

### Set up databases

### Set up a Kubernetes cluster

Once Kubernetes is deployed, the other things are pretty easy.