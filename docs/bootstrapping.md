# Bootstrapping

In the event that everything is lost, this guide should describe how the cluster is to be bootstrapped from zero.

## Setting up the Machines and VMs

On all nodes with at least 8GB of RAM, install [Proxmox](https://proxmox.com/en/).

On all other nodes, install bare-metal [Ubuntu Server](https://ubuntu.com/download/server).

## FreeIPA

On one Proxmox node, create a [Fedora Server](https://getfedora.org/en/server/download/) VM. This will be for FreeIPA. It should have at least 2GB of RAM.

```s
# TODO FreeIPA installation
```

## Kubernetes Cluster

Using the rest of the resources on the Proxmox servers, create Ubuntu Server VMs.

Using `k3sup`, install a Kubernetes cluster.



