{ config, lib, ... }:
let
  cfg = config.astral.mount-root-to-home;
in
{
  options.astral.mount-root-to-home = {
    enable = lib.mkEnableOption "astral.mount-root-to-home";
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/root" = {
      device = "/home/root";
      options = [ "bind" ];
      depends = [ "/home" ];
    };
  };
}
