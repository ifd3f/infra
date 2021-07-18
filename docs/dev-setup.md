# Development Environment Setup

## Kubernetes

We test our Kubernetes deployments using Minikube.

1. Start up Minikube with `minikube start`
2. Open this VS Code workspace in a dev container, and it will have a lot of useful tools

### Setting up KubeDB

A lot of things I'm deploying need databases, which is why I'm using KubeDB to manage those databases.

1. Acquire a license for KubeDB, following [these instructions](https://kubedb.com/docs/v2021.01.26/setup/install/community/) with the form [here](https://license-issuer.appscode.com/), and put the file in `kubernetes/helmfile.d/kubedb/license.txt`
2. Run `helmfile -f kubernetes/helmfile.d/00-kubedb.yml` to install kubedb

