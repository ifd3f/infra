# Infrastructure

[![Build and check all targets](https://github.com/astridyu/infra/actions/workflows/check-targets.yml/badge.svg)](https://github.com/astridyu/infra/actions/workflows/check-targets.yml)

This repo holds everything needed to set up my all my infrastructure, including personal computers and homelab servers. This includes things like:

- Scripts
- Kubernetes manifests
- Ansible playbooks
- Terraform modules
- Dotfiles
- Nix configs

And so much more!

## Current Features

This list is not comprehensive and it is likely to expand.

- Public
  - Dockerized personal website services, served on Oracle Cloud and redeployed with Ansible
  - Cloudflare DNS, updated by Terraform
- Internal
  - PC fleet powered by modular NixOS configurations
  - Virtualization server powered by LXD/Qemu on NixOS
- Deployment
  - Consistent, immutable builds using Nix flakes
  - Highly-automated and dynamic CI pipeline, building all x86 systems and packages on every push

## Useful Links

- [cloud.astrid.tech](https://cloud.astrid.tech/), a Github Pages site acting as a wiki documenting this project. Also located in the [docs/](./docs) folder.
- [An article on my website](https://astrid.tech/projects/infra/) about this project, including some of its history
