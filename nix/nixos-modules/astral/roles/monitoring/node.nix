{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.roles.monitoring.node;
  ecfg = config.services.prometheus.exporters;
in {
  options.astral.roles.monitoring.node = {
    enable = mkEnableOption "monitored node role";
    vhost = mkOption {
      description = "What vhost to make nginx listen on";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    astral.roles.monitoring.node.vhost = mkDefault config.networking.fqdn;

    services.prometheus.exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      systemd = {
        enable = true;
        port = 9558;
      };
      nginx = {
        enable = true;
        port = 9113;
      };
    };

    services.nginx.enable = true;
    services.nginx.virtualHosts.${cfg.vhost} = {
      enableACME = true;
      onlySSL = true;

      # Enforce client authentication
      extraConfig = ''
        ssl_client_certificate ${./prometheus.pem};
        ssl_verify_depth 3;
        ssl_verify_client on;
      '';

      locations = {
        "/metrics/node".proxyPass =
          "http://127.0.0.1:${toString ecfg.node.port}/metrics";
        "/metrics/nginx".proxyPass =
          "http://127.0.0.1:${toString ecfg.nginx.port}/metrics";
        "/metrics/systemd".proxyPass =
          "http://127.0.0.1:${toString ecfg.systemd.port}/metrics";
      };
    };
  };
}
