{ config, lib, ... }:
with lib; {
  options.astral.mount-root-to-home.enable =
    mkEnableOption "mounting root to home";

  config = mkIf config.astral.mount-root-to-home.enable {
    fileSystems."/root" = {
      device = "/home/root";
      options = [ "bind" ];
      depends = [ "/home" ];
    };
  };
}
