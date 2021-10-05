# Infrastructure

This repo holds everything needed to set up my all my infrastructure, including personal computers and homelab servers. This includes things like:

- Scripts
- Kubernetes manifests
- Ansible playbooks
- Terraform modules
- Dotfiles
- NixOS

## Current Features

Much of this code is experimental and not used in production yet. However, there are some things that *are* being used to great effect:

- The Nix flake is being used to deploy my homelab servers
- Docker Compose, for setting up api.astrid.tech and aay.tw
- An automated Ansible system for redeploying said Docker services in Oracle Cloud
- My Cloudflare DNS setup is configured using Terraform so that I can have an auditable and manageable trail of changes

## Subfolder Summary

- `ansible/` - Ansible projects and roles
- `dev-env/` - Terraform and Packer scripts for setting up a local replica of my homelab for development
- `docker-compose/` - Old docker-compose projects
- `docs/` - Wiki (see it rendered at [cloud.astrid.tech](https://cloud.astrid.tech/))
- `home-manager/` - Home-manager configs, and dotfiles
- `images/` - Docker and Packer builders for containers, LXCs, and VMs
- `kubernetes/` - Kubernetes deployment configs
- `nixos/` - NixOS modules and systems
- `openwrt/` - OpenWRT configuration and scripts
- `terraform/` - Terraform projects

## Useful Links

- [cloud.astrid.tech](https://cloud.astrid.tech/), a Github Pages site acting as a wiki documenting this project. Also located in the [docs/](./docs) folder.
- [An article on my website](https://astrid.tech/projects/plebscale/) about this project


