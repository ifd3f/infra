{ pkgs, lib, config, inputs, ... }:
with lib;
let
  vs = config.vault-secrets.secrets;
  gcfg = config.services.grafana;
in {
  astral.backup.services.paths = [ "/var/lib/prometheus2" ];

  services.prometheus = {
    enable = true;
    checkConfig = "syntax-only";

    scrapeConfigs = let
      ecfg = config.services.prometheus.exporters;

      # TODO: set up mTLS
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
        job_name = "nginxlog";
        scrape_interval = "10s";
        metrics_path = "/metrics/nginxlog";
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
        inherit tls_config;

        scheme = "https";
        job_name = "postgres";
        scrape_interval = "10s";
        metrics_path = "/metrics/postgres";
        static_configs =
          [{ targets = [ "amiya.h.astrid.tech" "diluc.h.astrid.tech" ]; }];
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

  services.akkoma-prometheus-exporter."fedi.astrid.tech" = {
    enable = true;
    port = 8895;
  };
}
