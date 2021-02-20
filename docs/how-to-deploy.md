# How do I deploy...

## Monitoring Stack

### Requirements

- NFS
- Kubernetes

### Steps

1. Apply the Helm Charts (`kubernetes/helmfile.d`)
2. Apply the logging Kustomizations (`kubernetes/logging`)
3. Apply the metrics manifests (`kubernetes/metrics`)
4. In [Grafana](https://grafana.astrid.tech), log in and create the dashboards manually from the preconfigured JSONs (`kubernetes/metrics/grafana`)

## Firefly III

### Requirements

- MySQL
- Kubernetes
- NFS

### Steps

1. Spawn the database using the Terraform script (`terraform/`)
2. Apply the Kustomization (`kubernetes/firefly`)

## ELabFTW

### Requirements

- MySQL
- Kubernetes
- NFS

### Steps

1. Spawn the database using the Terraform script (`terraform/`)
2. Apply the Kustomization (`kubernetes/elabftw`)
