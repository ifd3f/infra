{ pkgs, lib, config, ... }:
with lib;
let
  vs = config.vault-secrets.secrets;
  gcfg = config.services.grafana;
in {
  astral.backup.services.paths = [ "/var/lib/grafana" "/var/lib/prometheus2" ];

  # vault kv put kv/prometheus-xmpp-alerts/environment XMPP_USER_PASSWORD=@
  vault-secrets.secrets.prometheus-xmpp-alerts = {
    group = "prometheus-xmpp-alerts-secrets";
  };

  users.groups.prometheus-xmpp-alerts-secrets = { };

  systemd.services.prometheus-xmpp-alerts.serviceConfig.EnvironmentFile =
    "${vs.prometheus-xmpp-alerts}/environment";

  services.prometheus.xmpp-alerts = {
    enable = true;
    settings = {
      jid = "alertmanager@xmpp.femboy.technology";
      to_jid = "ifd3f@xmpp.femboy.technology";
      password_command = "echo $XMPP_USER_PASSWORD";
      listen_address = "127.0.0.1";
      listen_port = 9199;
    };
  };
}
