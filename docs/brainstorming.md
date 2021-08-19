# Big Brainstorm Document

## Before 2021-08-07

```
- main wifi router
- server (bongus) cascaded behind it
- bootstrapping process:
 1. The hard part?
  1. Begin behind travel router
  2. Set up clementine as the gold server, use it to configure travel router
  3. install freeipa on bare fedora badtop (ipa0) for ldap n shit
  4. Configure badtop to be the dns server
  5. Set up bongus, thonkpad, cracktop as clustered proxmox and connected to ldap
  6. Set up fileshares in proxmox

Super bootstrap script!
Nodes needed for simulation:
- bongus: Deb preseed qemu
- thonkpad: Deb preseed qemu
- cracktop: Deb preseed qemu
- clementine: Docker
Development environment:

---

Outer net 
Inner net 

bongus: outer, inner 
clementine: outer
badtop/ipa0: inner 
cracktop: inner 

If innergs exists, is there even a point to clementine? Could just build/trigger innergs from laptop

- Set up bongus 
Ansible: Generate root password
Ansible: Install proxmox

- Set up InnerGS
P: Build the LXC
A/T: Create the lxc 
A: trigger stuff on it

- Set up permafrost
Packer: build lxc
Ansible/terraform: Upload lxc with pfsense
Ansible, continuously: Upload pfsense config

- Set up ipa0 from innergs
A: Install FreeIPA
A: Configure it

- Set up vault
P: Build lxc
A/T: Create lxc
A: Configuration

- Set up ipa1 from innergs
A/T: Create vm
A: Configure it

- Set up Proxmox ldap
A: a lotta configs, also add ipa1
```