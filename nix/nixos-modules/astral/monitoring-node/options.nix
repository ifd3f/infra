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
      type = types.enum [ "https" "tailscale" null ];
      default = null;
    };

    exporters = mkOption {
      description = ''
        What exporters this host exposes.

        This should get automatically set based on what services are enabled.
      '';
      type = with types; listOf str;
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = cfg.scrapeTransport != null;
      message =
        "To enable `astral.monitoring-node`, you must specify a non-null `astral.monitoring-node.scrapeTransport`.";
    }];

    astral.monitoring-node.vhost = mkDefault
      (if cfg.scrapeTransport == "tailscale" then
        "${config.networking.hostName}.hyrax-hops.ts.net"
      else
        config.networking.fqdn);
  };
}
