# Kubernetes

This folder contains manifests and charts used for different apps that I deploy.

## Kustomization

The following items are deployed with Kustomization:

- Firefly III
- ELabFTW
- Fluentd log aggregation config

## Helm Charts

The following items are deployed using Helm Charts using a modular Helmfile structure (see `helmfile.d/`):

- Monitoring stack
  - Grafana
  - Prometheus
  - Prometheus Exporters
  - Loki
  - Fluentd
  - Fluent-Bit
- Apache Spark
- QBitTorrent
