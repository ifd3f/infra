# Development Environment Setup

I have multiple types of development environments for different types of development.

## Full Deployment Development

To test the full deployment of my homelab, I use Libvirt VMs provisioned by Terraform, with images built by Packer. Please see [dev-env/README.md](https://github.com/astralbijection/infrastructure/blob/main/dev-env/README.md) for more information on how to set that up.

## Kubernetes Development

We test our Kubernetes deployments using Minikube.

First, set up Minikube on your machine (not a container) with 

```sh
minikube start 
minikube addons enable ingress
minikube ssh "sudo apt-get update && sudo apt-get install -y open-iscsi"  # for Longhorn
```

Now, you can open this VS Code workspace in a dev container.

### Post-docker startup configurations

In the devcontainer, run:

```sh
ansible-playbook ansible/setup_devcontainer.yaml
```

Rerun this whenever you update any ingresses.

### Setting up Longhorn

```sh
helmfile -f kubernetes/helmfile.d/00-longhorn.yaml
```

### Setting up KubeDB

A lot of things I'm deploying need databases, which is why I'm using KubeDB to manage those databases.

1. Acquire a license for KubeDB, following [these instructions](https://kubedb.com/docs/v2021.01.26/setup/install/community/) with the form [here](https://license-issuer.appscode.com/), and put the file in `kubernetes/helmfile.d/kubedb/license.txt`
2. Run `helmfile -f kubernetes/helmfile.d/00-kubedb.yml` to install kubedb

## Appendix: Utilities included in the Dev Container

### Configuration and Provisioning

- Ansible
- Terraform

### Kubernetes

- kubectl (with tab-completion)
- kgctl (Kilo)
- helm
- helm-diff
- helmfile
- k3sup
- kubedb CLI

### Cloud service CLIs

- Oracle Cloud CLI
- Google Cloud

### Network tools

- netcat
- whois
- dnsutils
- arping
- host
- tracepath
- clockdiff

### Database Clients

- MySQL
- PostgreSQL
- InfluxDB

### Other

- Bitwarden
- Neovim
- graphviz-online.sh, a simple script I wrote:

```
root ➜ /workspaces/infrastructure (main ✗) $ kgctl graph | graphviz-online.sh 
https://dreampuf.github.io/GraphvizOnline/#digraph%20kilo%20%7B%0A%09label%3D%2210.4.0.0%2F16%22%3B%0A%09labelloc%3Dt%3B%0A%09outputorder%3Dnodesfirst%3B%0A%09overlap%3Dfalse%3B%0A%09%22minikube%22-%3E%22astrid%22%5B%20dir%3Dboth%2C%20style%3Ddashed%20%5D%3B%0A%09subgraph%20%22cluster_location_location%3A%22%20%7B%0A%09label%3D%22location%3A%22%3B%0A%09style%3D%22dashed%2Crounded%22%3B%0A%09%22minikube%22%20%5B%20label%3D%22location%3A%5Cnminikube%5Cn10.244.0.0%2F24%5Cn192.168.49.2%5Cn10.4.0.1%5Cn192.168.49.2%3A51820%22%2C%20rank%3D1%2C%20shape%3Dellipse%20%5D%3B%0A%0A%7D%0A%3B%0A%09subgraph%20%22cluster_peers%22%20%7B%0A%09label%3D%22peers%22%3B%0A%09style%3D%22dashed%2Crounded%22%3B%0A%09%22astrid%22%20%5B%20label%3D%22astrid%5Cn%0A%22%2C%20shape%3Dellipse%20%5D%3B%0A%0A%7D%0A%3B%0A%0A%7D
```