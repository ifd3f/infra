# Development Environment Setup

## Kubernetes

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

### Setting up Longhorn

```sh
helmfile -f kubernetes/helmfile.d/00-longhorn.yaml
```

### Setting up KubeDB

A lot of things I'm deploying need databases, which is why I'm using KubeDB to manage those databases.

1. Acquire a license for KubeDB, following [these instructions](https://kubedb.com/docs/v2021.01.26/setup/install/community/) with the form [here](https://license-issuer.appscode.com/), and put the file in `kubernetes/helmfile.d/kubedb/license.txt`
2. Run `helmfile -f kubernetes/helmfile.d/00-kubedb.yml` to install kubedb

