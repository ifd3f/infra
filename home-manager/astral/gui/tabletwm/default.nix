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
      config = ./xmonad.hs;
      extraPackages = self: with pkgs.haskellPackages; [
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
      };
    };

    programs.autorandr = {
      enable = true;
      profiles.portable = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0030e45505a1000010001a0104a51a117803ee95a3544c99260f5054000000010101010101010101010101010101013f7fb0a0a020347030203a0004ad10000019000000fd00303c000021040a141414141414000000fe004c47445f4d50302e325f0a2020000000fe004c503132335751313132363034003f";
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "2736x1824";
            rate = "60.00";
            position = "0x0";
            crtc = 0;
            # 267 PPI (https://www.microsoft.com/en-us/surface/devices/surface-pro-6)
            dpi = 144;
          };
        };
      };
    };

    programs.rofi = {
      enable = true;
      theme = "${pkgs.rofi}/share/rofi/themes/glue_pro_blue.rasi";

      extraConfig = {
        modi = "window,drun,run,ssh";
        levenshtein-sort = true;
        lines = 15;
        sidebar-mode = true;
      };
    };

    services.polybar = {
      enable = true;
      config = ./polybar.ini;
      script = ''
        polybar top &
      '';
    };

    home.packages = with pkgs; [ meslo-lgs-nf onboard ];
  });
}

