{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.astral.roles.monitoring.center;
  gcfg = config.services.grafana;
in {
  options.astral.roles.monitoring.center.enable =
    mkEnableOption "monitoring center role";

  config = mkIf cfg.enable {
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

      scrapeConfigs = let ecfg = config.services.prometheus.exporters;
      in [
        {
          job_name = "node";
          scrape_interval = "10s";
          static_configs =
            [{ targets = [ "127.0.0.1:${toString ecfg.node.port}" ]; }];
        }
        {
          job_name = "nginx";
          scrape_interval = "10s";
          static_configs =
            [{ targets = [ "127.0.0.1:${toString ecfg.nginx.port}" ]; }];
        }
        {
          job_name = "systemd";
          scrape_interval = "10s";
          static_configs =
            [{ targets = [ "127.0.0.1:${toString ecfg.systemd.port}" ]; }];
        }
      ];
    };

    services.nginx.statusPage = true;

    services.nginx.virtualHosts = {
      ${gcfg.settings.server.domain} = {
        enableACME = true;
        forceSSL = true;

        extraConfig = ''
          error_page 502 /502.html;
        '';

        locations."= /502.html" = {
          root = ../../custom-nginx-errors/static;
          extraConfig = ''
            internal;
          '';
        };

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
