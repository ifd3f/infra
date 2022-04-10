# A 
{ pkgs, lib, ... }:
{
  options.astral.gui.tabletwm = {
    enable = mkOption {
      description = "Enable window manager configuration for tablet.";
      default = false;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.gui.xmonad;
  in (mkIf cfg.enable {
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
      haskellPackages = with pkgs.haskellPackages; [
        containers
        X11
      ];
    };
  });
}
