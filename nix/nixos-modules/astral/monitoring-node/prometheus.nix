{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.monitoring-node;
  ecfg = config.services.prometheus.exporters;
  supportedExporters =
    [ "node" "nginx" "systemd" "bind" "postgres" ];
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
