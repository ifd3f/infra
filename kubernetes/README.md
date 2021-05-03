# Kubernetes

This folder contains manifests and charts used for different apps that I deploy.

## Kustomization

The following items are deployed with Kustomization:

- Firefly III
- ELabFTW
- Fluentd log aggregation config

## Helm Charts

The following items are deployed using Helm Charts using a modular Helmfile structure (see `helmfile.d/`):

- KubeDB
- Rancher Longhorn
- External DNS
- Monitoring stack
  - Grafana
  - Prometheus
  - Loki
  - Fluentd
  - Fluent-Bit
  - Kubernetes Dashboard
- Apache Spark
- QBitTorrent
