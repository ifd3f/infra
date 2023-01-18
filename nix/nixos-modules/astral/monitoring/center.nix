{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.astral.monitoring.center;
  gcfg = config.services.grafana;
  lcfg = config.services.loki;
in {
  options.astral.monitoring.center = {
    enable = mkEnableOption "monitoring center role";

    sslKeyFile = mkOption {
      type = types.path;
      description = "Path to SSL key";
      default = "/var/lib/secrets/prometheus/prometheus.key";
    };
  };

  config = mkIf cfg.enable {
    astral.custom-nginx-errors.virtualHosts = [ "grafana.astrid.tech" ];

    services.grafana = {
      enable = true;
      settings = {
        server.domain = "grafana.astrid.tech";
        server.http_port = 2342;
        server.addr = "127.0.0.1";
      };
    };

    services.prometheus = {
      enable = true;
      checkConfig = "syntax-only";

      scrapeConfigs = let
        ecfg = config.services.prometheus.exporters;
        tls_config = {
          # ca_file = "${../../ca.crt}";
          # cert_file = "${./prometheus.pem}";
          # key_file = cfg.sslKeyFile;
        };
        targets = [
          "amiya.h.astrid.tech"
          "bennett.h.astrid.tech"
          "diluc.h.astrid.tech"
          "durin.h.astrid.tech"
          "yato.h.astrid.tech"
        ];
      in [
        {
          inherit tls_config;

          scheme = "https";
          job_name = "node";
          scrape_interval = "10s";
          metrics_path = "/metrics/node";
          static_configs = [{ inherit targets; }];
        }
        {
          inherit tls_config;

          scheme = "https";
          job_name = "nginx";
          scrape_interval = "10s";
          metrics_path = "/metrics/nginx";
          static_configs = [{ inherit targets; }];
        }
        {
          inherit tls_config;

          scheme = "https";
          job_name = "systemd";
          scrape_interval = "10s";
          metrics_path = "/metrics/systemd";
          static_configs = [{ inherit targets; }];
        }
        {
          inherit tls_config;

          scheme = "https";
          job_name = "bind";
          scrape_interval = "10s";
          metrics_path = "/metrics/bind";
          static_configs = [{ targets = [ "diluc.h.astrid.tech" ]; }];
        }
        {
          scheme = "http";
          job_name = "akkoma";
          scrape_interval = "5s";
          metrics_path = "/";
          static_configs = [{ targets = [ "localhost:8895" ]; }];
        }
      ];
    };

    services.akkoma-prometheus-exporter."fedi.astrid.tech".port = 8895;

    services.loki = {
      enable = true;

      extraFlags = [ "-config.expand-env=true" ];

      configuration = {
        common = { ring.kvstore.store = "memberlist"; };
        auth_enabled = false;
        compactor = {
          compaction_interval = "5m";
          shared_store = "s3";
          working_directory = "/var/lib/loki/data/compactor";
        };
        ingester = {
          chunk_idle_period = "5m";
          chunk_retain_period = "30s";
          lifecycler = {
            final_sleep = "0s";
            ring.replication_factor = 1;
          };
        };
        limits_config = {
          enforce_metric_name = false;
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
        };
        memberlist = {
          abort_if_cluster_join_fails = false;
          bind_port = 7946;
          max_join_backoff = "1m";
          max_join_retries = 10;
          min_join_backoff = "1s";
        };
        schema_config = {
          configs = [{
            from = "2023-01-18";
            index = {
              period = "24h";
              prefix = "index_";
            };
            object_store = "s3";
            schema = "v11";
            store = "boltdb-shipper";
          }];
        };
        server = {
          http_listen_address = "0.0.0.0";
          http_listen_port = 3100;
        };
        storage_config = {
          aws = {
            s3 = "https://s3.us-west-000.backblazeb2.com/ifd3f-logging";
            access_key_id = "\${S3_ACCESS}";
            secret_access_key = "\${S3_SECRET}";
            s3forcepathstyle = true;
          };
          boltdb_shipper = {
            active_index_directory = "/var/lib/loki/index";
            cache_location = "/var/lib/loki/index_cache";
            shared_store = "s3";
          };
        };
      };
    };

    systemd.services.loki.serviceConfig.EnvironmentFile =
      "/var/lib/secrets/loki/secrets.env";

    services.nginx.statusPage = true;
    services.nginx.virtualHosts = {
      ${gcfg.settings.server.domain} = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass =
            "http://127.0.0.1:${toString gcfg.settings.server.http_port}";
          proxyWebsockets = true;

          # needed to prevent 'Origin not allowed'
          # see: https://community.grafana.com/t/after-update-to-8-3-5-origin-not-allowed-behind-proxy/60598/4
          extraConfig = ''
            proxy_set_header Host grafana.astrid.tech;
          '';
        };
      };

      "loki.astrid.tech" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:"
            + toString lcfg.configuration.server.http_listen_port;
          proxyWebsockets = true;
        };
      };
    };
  };
}
