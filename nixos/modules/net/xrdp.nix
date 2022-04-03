{ config, lib, pkgs, ... }:
with lib; {
  options.astral.net.xrdp.enable = mkOption {
    description = "Enable to use customized xrdp configs.";
    default = false;
    type = types.bool;
  };

  config = let cfg = config.astral.net.xrdp;
  in mkIf cfg.enable {
    services.xrdp = {
      enable = true;
      openFirewall = true;
    };
  };
}
