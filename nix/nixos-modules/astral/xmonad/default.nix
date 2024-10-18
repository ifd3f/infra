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
      gnome.gnome-keyring.enable = true;
      upower.enable = true;

      libinput = {
        enable = true;
        touchpad.disableWhileTyping = true;
      };

      defaultSession = "none+xmonad";

      xserver = {
        enable = true;

        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };

        xkb.layout = "us";
        xkb.options = "caps:ctrl_modifier";
      };
    };

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    systemd.services.upower.enable = true;
  };
}
