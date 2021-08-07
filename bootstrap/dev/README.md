# Libvirt Development Environment

Because bootstrapping the cluster is a very complex ordeal, a local, virtualized environment may be helpful for testing my code. That's what this folder is for.

Depending you how your computer is set up, Packer and Terraform may need to be run as root.

## Packer

The images created by packer should emulate what's on my servers, as closely as possible. They are initialized using preseed files.

## Terraform

The terraform script provisions and starts up all 3 servers in libvirt.
