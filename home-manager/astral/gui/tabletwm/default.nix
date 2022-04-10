{ config, pkgs, lib, ... }: {
  options.astral.gui.tabletwm = {
    enable = lib.mkOption {
      description = "Enable window manager configuration for tablet.";
      default = false;
      type = lib.types.bool;
    };
  };

  config = let cfg = config.astral.gui.tabletwm;
  in (lib.mkIf cfg.enable {
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = null;
      haskellPackages = with pkgs.haskellPackages; [
        containers
        X11
      ];
    };
  });
}
