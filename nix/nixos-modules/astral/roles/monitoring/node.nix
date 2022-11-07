{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.roles.monitoring.node;
  ecfg = config.services.prometheus.exporters;
in {
  options.astral.roles.monitoring.node.enable =
    mkEnableOption "monitored node role";

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
      };
      nginx = {
        enable = config.services.nginx.enable;
        port = 9113;
      };
    };
  };
}
