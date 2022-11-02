{ pkgs, lib, config, ... }: {
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

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      nginx = {
        enable = true;
        port = 9113;
      };
    };

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [
            "127.0.0.1:${
              toString config.services.prometheus.exporters.node.port
            }"
          ];
        }];
      }
      {
        job_name = "nginx";
        static_configs = [{
          targets = [
            "127.0.0.1:${
              toString config.services.prometheus.exporters.nginx.port
            }"
          ];
        }];
      }
    ];
  };

  services.nginx.statusPage = true;

  services.nginx.virtualHosts = let gcfg = config.services.grafana;
  in {
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
}
