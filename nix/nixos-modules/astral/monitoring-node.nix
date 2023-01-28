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
      default = true;
    };
  };

  config = mkIf cfg.enable {
    astral.monitoring-node.vhost = mkDefault
      (if cfg.scrapeTransport == "tailscale" then
        "${config.networking.hostName}.hyrax-hops.ts.net"
      else
        config.networking.fqdn);

    astral.acme.enable = cfg.scrapeTransport == "https";

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
      nginxlog = {
        enable = true;
        port = 9117;
        settings = {
          namespaces = [{
            format = ''
              $remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"'';
            histogram_buckets =
              [ 5.0e-3 1.0e-2 2.5e-2 5.0e-2 0.1 0.25 0.5 1 2.5 5 10 ];
            labels = {
              app = "application-one";
              environment = "production";
              foo = "bar";
            };
            name = "app1";
            source = { files = [ "/var/log/nginx/app1/access.log" ]; };
          }];
        };
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
        scrape_configs = [
          {
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
          }

          {
            job_name = "nginx";
            static_configs = [{
              labels = {
                host = cfg.vhost;
                job = "nginx";
                __path__ = "/var/log/nginx/*";
              };
            }];
          }
        ];

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

      virtualHosts.${cfg.vhost} = mkMerge [
        {
          locations = mkMerge ((map (name:
            let thisCfg = ecfg.${name};
            in mkIf thisCfg.enable {
              "/metrics/${name}".proxyPass =
                "http://127.0.0.1:${toString thisCfg.port}/metrics";
            }) [ "node" "nginx" "nginxlog" "systemd" "bind" "postgres" ])

            ++ [{
              "/promtail".proxyPass = let
                promtailPort =
                  config.services.promtail.configuration.server.http_listen_port;
              in "http://127.0.0.1:${toString promtailPort}/metrics";
            }]);
        }

        (mkIf (cfg.scrapeTransport == "https") {
          enableACME = true;
          forceSSL = true;

          # TODO: figure out mTLS
          extraConfig = ''
            # durin
            allow 192.9.241.223;

            # amiya
            allow 208.87.130.175;

            allow 127.0.0.1;
            allow ::1;

            deny all;
          '';
        })
        (mkIf (cfg.scrapeTransport == "tailscale") {
          # TODO: figure out tail auth?
          extraConfig = ''
            # durin
            allow 100.91.90.4;
            allow fd7a:115c:a1e0:ab12:4843:cd96:625b:5a04;

            # amiya
            allow 100.117.107.85;
            allow fd7a:115c:a1e0:ab12:4843:cd96:6275:6b55;

            allow 127.0.0.1;
            allow ::1;

            deny all;
          '';
        })
      ];
    };

    users.users.promtail.extraGroups = [ "nginx" ];
  };
}
