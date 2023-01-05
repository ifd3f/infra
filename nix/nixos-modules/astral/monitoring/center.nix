{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.astral.monitoring.center;
  gcfg = config.services.grafana;

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
      ];
    };

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
    };
  };
}
