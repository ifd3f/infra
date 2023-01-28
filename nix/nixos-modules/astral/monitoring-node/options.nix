{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.monitoring-node;
  ecfg = config.services.prometheus.exporters;
in {
  options.astral.monitoring-node = {
    enable = mkEnableOption "monitored node role";

    vhost = mkOption {
      description = "What vhost to make nginx listen on";
      type = types.str;
    };

    scrapeTransport = mkOption {
      description =
        "What transport will Prometheus and Loki use to monitor this host?";
      type = types.enum [ "https" "tailscale" ];
    };

    exporters = mkOption {
      description = ''
        What exporters this host exposes.

        This should get automatically set based on what services are enabled.
      '';
      type = with types; listOf str;
    };
  };

  config = {
    astral.monitoring-node.vhost = mkDefault
      (if cfg.scrapeTransport == "tailscale" then
        "${config.networking.hostName}.hyrax-hops.ts.net"
      else
        config.networking.fqdn);
  };
}
