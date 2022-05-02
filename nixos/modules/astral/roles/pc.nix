{ config, lib, pkgs, ... }:
with lib; {
  options.astral.roles.pc.enable = mkOption {
    description = "A graphics-enabled PC I would directly use";
    default = false;
    type = types.bool;
  };

  config = mkIf config.astral.roles.pc.enable {
    environment.systemPackages = with pkgs; [
      home-manager
      openconnect
      ventoy-bin
    ];

    users.mutableUsers = true;

    services.geoclue2 = {
      enable = true;
      enableWifi = true;
    };

    astral = {
      program-sets = {
        browsers = true;
        cad = true;
        chat = true;
        dev = true;
        office = true;
        security = true;
        x11 = true;
      };
      hw.kb-flashing.enable = true;
      virt = {
        docker.enable = true;
        lxc.enable = false;
        libvirt = {
          enable = true;
          virt-manager.enable = true;
        };
      };
      net = {
        xrdp.enable = true;
        sshd.enable = true;
      };
      infra-update = {
        enable = true;
        dates = "*-*-* 3:00:00 US/Pacific";
      };
    };

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    
    services.printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint gutenprintBin ];
    };

    services.xserver = {
      enable = true;

      displayManager = { lightdm.enable = true; };

      desktopManager = {
        xterm.enable = false;
        plasma5 = {
          enable = true;
          useQtScaling = true;
        };
      };

      windowManager.i3.enable = true;
    };
  };
}
