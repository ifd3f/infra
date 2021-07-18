# Monitoring Stack

## Requirements

- NFS
- Kubernetes

## Steps

Apply the relevant things:

```sh
helmfile -f kubernetes/helmfile.d/monitoring.yaml apply
kubectl apply -k kubernetes/logging  # further configs for logging
```

For now, the metrics manifests are individually manually applied in `kubernetes/metrics`.

Finally, in [Grafana](https://grafana.s.astrid.tech), log in and create the dashboards manually from the preconfigured JSONs (`kubernetes/metrics/grafana`).
