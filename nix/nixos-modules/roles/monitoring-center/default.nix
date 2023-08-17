inputs: {
  imports =
    [ ./grafana.nix (import ./prometheus.nix inputs) ./xmpp-alerts.nix ];
}
