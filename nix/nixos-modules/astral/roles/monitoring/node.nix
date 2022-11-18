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
    astral.acme.enable = true;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };

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
      forceSSL = true;

      # TODO: figure out mTLS
      extraConfig = ''
        allow 173.212.242.107;
        allow 2a02:c207:2087:999::1;

        allow 127.0.0.1;
        allow ::1;

        deny all;
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
