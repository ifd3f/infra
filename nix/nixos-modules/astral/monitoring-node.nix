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
  };

  config = mkIf cfg.enable {
    astral.monitoring-node.vhost = mkDefault config.networking.fqdn;
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
      postgres = {
        enable = config.services.postgresql.enable;
        runAsLocalSuperUser = true;
        port = 9187;
        extraFlags = [ "--auto-discover-databases" ];
      };
    };

    services.promtail = {
      enable = true;
      configuration = {
        clients = [{ url = "https://loki.astrid.tech/loki/api/v1/push"; }];
        scrape_configs = [{
          job_name = "journal";
          journal = {
            json = true;
            path = "/var/log/journal";
            max_age = "12h";
            labels = {
              host = cfg.vhost;
              job = "journal";
              "__path__" = "/var/log/journal";
            };
          };

          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
            {
              source_labels = [ "__journal_priority" ];
              target_label = "priority";
            }
            {
              source_labels = [ "__journal_syslog_identifier" ];
              target_label = "syslog_id";
            }
          ];
        }];
        server = {
          http_listen_port = 9832;
          http_path_prefix = "/promtail";
          grpc_listen_port = 0;
        };
      };
    };

    services.nginx = {
      enable = true;
      statusPage = true;

      virtualHosts.${cfg.vhost} = {
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
          }) [ "node" "nginx" "systemd" "bind" "postgres" ])

          ++ [{
            "/promtail".proxyPass =
              "http://127.0.0.1:${toString promtailPort}/metrics";
          }]);
      };
    };
  };
}
