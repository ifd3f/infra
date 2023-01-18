{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.monitoring.node;
  ecfg = config.services.prometheus.exporters;
in {
  options.astral.monitoring.node = {
    enable = mkEnableOption "monitored node role";
    vhost = mkOption {
      description = "What vhost to make nginx listen on";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    astral.monitoring.node.vhost = mkDefault config.networking.fqdn;
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
        extraFlags = [
          "--log.level=error"
          "--systemd.collector.enable-file-descriptor-size"
          "--systemd.collector.enable-ip-accounting"
          "--systemd.collector.enable-restart-count"
        ];
      };
      nginx = {
        enable = true;
        port = 9113;
      };
    };

    services.promtail = {
      enable = true;
      configuration = {
        clients = [{ url = "https://loki.astrid.tech/loki/api/v1/push"; }];
        scrape_configs = [{
          job_name = "journal";
          journal = {
            path = "/var/log/journal";
            max_age = "7d";
            labels = {
              host = cfg.vhost;
              job = "journal";
              "__path__" = "/var/log/journal";
            };
          };
        }];
        server = {
          http_listen_port = 9832;
          http_path_prefix = "/promtail";
          grpc_listen_port = 0;
        };
      };
    };

    services.nginx.enable = true;
    services.nginx.virtualHosts.${cfg.vhost} = {
      enableACME = true;
      forceSSL = true;

      # TODO: figure out mTLS
      extraConfig = ''
        allow 192.9.241.223;

        allow 127.0.0.1;
        allow ::1;

        deny all;
      '';

      locations = let
        promtailPort =
          config.services.promtail.configuration.server.http_listen_port;
      in mkMerge ((map (name:
        let thisCfg = ecfg.${name};
        in mkIf thisCfg.enable {
          "/metrics/${name}".proxyPass =
            "http://127.0.0.1:${toString thisCfg.port}/metrics";
        }) [ "node" "nginx" "systemd" "bind" ])

        ++ [{
          "/promtail".proxyPass =
            "http://127.0.0.1:${toString promtailPort}/metrics";
        }]);
    };
  };
}
