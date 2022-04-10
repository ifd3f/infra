{ config, lib, pkgs, ... }: {
  options.astral.xmonad = {
    enable = lib.mkOption {
      description = "Use xmonad";
      default = false;
      type = lib.types.bool;
    };
  };

  # https://gvolpe.com/blog/xmonad-polybar-nixos/#configuration
  config = let cfg = config.astral.xmonad;
  in lib.mkIf cfg.enable {
    services = {
      gnome3.gnome-keyring.enable = true;
      upower.enable = true;

      xserver = {
        enable = true;
        layout = "us";

        libinput = {
          enable = true;
          disableWhileTyping = true;
        };

        # displayManager.defaultSession = "none+xmonad";

        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };

        xkbOptions = "caps:ctrl_modifier";
      };
    };

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    systemd.services.upower.enable = true;
  };
}
