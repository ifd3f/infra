{ config, pkgs, lib, ... }: {
  options.astral.gui.xmonad = {
    enable = lib.mkOption {
      description = "Enable window manager configuration for tablet.";
      default = false;
      type = lib.types.bool;
    };
  };

  config = let cfg = config.astral.gui.xmonad;
  in (lib.mkIf cfg.enable {
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
      extraPackages = self:
        with pkgs.haskellPackages; [
          containers
          monad-logger
          dbus
          X11
        ];
    };

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          size = 8;
          normal.family = "MesloLGS NF";
        };
        window = {
          opacity = 0.9;
          decorations = "none";
        };
      };
    };

    programs.rofi = {
      enable = true;
      theme = "${pkgs.rofi}/share/rofi/themes/DarkBlue";

      extraConfig = {
        modi = "combi";
        combi-modi = "drun,run,window";
        levenshtein-sort = true;
        lines = 20;
        sidebar-mode = true;
      };
    };

    services.picom = {
      enable = true;
      blur = true;
    };

    services.polybar = {
      enable = true;
      config = ./polybar.ini;
      script = ''
        polybar top &
      '';
    };

    home.packages = with pkgs; [
      feh
      flameshot
      lightlocker
      onboard
      pulseaudio
      redshift
      xfce.xfce4-panel
      xfce.xfce4-panel-profiles
      xorg.xmessage

      meslo-lgs-nf
      roboto
      tamsyn
    ];
  });
}

