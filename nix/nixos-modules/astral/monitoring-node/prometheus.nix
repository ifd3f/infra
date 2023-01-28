{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.monitoring-node;
  ecfg = config.services.prometheus.exporters;
  supportedExporters =
    [ "node" "nginx" "nginxlog" "systemd" "bind" "postgres" ];
in {
  config = mkIf cfg.enable {
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

    services.nginx.virtualHosts."${cfg.vhost}".locations = mkMerge (map (name:
      let thisCfg = ecfg.${name};
      in mkIf thisCfg.enable {
        "/metrics/${name}".proxyPass =
          "http://127.0.0.1:${toString thisCfg.port}/metrics";
      }) supportedExporters);

    astral.monitoring-node.exporters =
      filter (name: ecfg.${name}.enable) supportedExporters;
  };

}
