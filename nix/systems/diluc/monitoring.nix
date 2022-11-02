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

  services.nginx.virtualHosts = {
    ${config.services.grafana.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
      };
    };
  };
}
