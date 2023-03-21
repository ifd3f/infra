{ inputs, lib, ... }:
with lib;
let inherit (inputs.self) nixosConfigurations;
in rec {
  supportedExporters =
    [ "node" "nginx" "systemd" "bind" "postgres" ];

  nixosKeys = (filter (host:
    !(hasPrefix "__" host)
    && nixosConfigurations."${host}".config.astral.monitoring-node.enable)
    (attrNames nixosConfigurations));

  monitoredHosts = with builtins;
    map (host: nixosConfigurations."${host}".config.astral.monitoring-node)
    nixosKeys;

  # TODO: set up mTLS
  tls_config = {
    # ca_file = "${../../ca.crt}";
    # cert_file = "${./prometheus.pem}";
    # key_file = cfg.sslKeyFile;
  };
  brokenHosts = with builtins;
    map (cfg: cfg.vhost)
    (filter (cfg: cfg.scrapeTransport == null) monitoredHosts);

  tailscaleTargets =
    filter (cfg: cfg.scrapeTransport == "tailscale") monitoredHosts;

  httpsTargets = filter (cfg: cfg.scrapeTransport == "https") monitoredHosts;

  scrapeConfigs =

    forEach supportedExporters (e: {
      inherit tls_config;

      scheme = "http";
      job_name = "${e}-tailscale";
      scrape_interval = "15s";
      metrics_path = "/metrics/${e}";
      static_configs = [{
        targets = with builtins;
          concatMap (cfg: if elem e cfg.exporters then [ cfg.vhost ] else [ ])
          tailscaleTargets;
      }];
    })

    ++ forEach supportedExporters (e: {
      inherit tls_config;

      scheme = "https";
      job_name = "${e}-https";
      scrape_interval = "15s";
      metrics_path = "/metrics/${e}";
      static_configs = [{
        targets = with builtins;
          concatMap (cfg: if elem e cfg.exporters then [ cfg.vhost ] else [ ])
          httpsTargets;
      }];
    });
}
