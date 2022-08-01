{ config, lib, pkgs, ... }:
with lib; {
  options.astral.roles.pc.enable = mkOption {
    description = "A graphics-enabled PC I would directly use";
    default = false;
    type = types.bool;
  };

  config = mkIf config.astral.roles.pc.enable {
    fonts.fonts = with pkgs; [
      corefonts
      dejavu_fonts
      dina-font
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-emoji
      open-fonts
      proggyfonts
      redhat-official-fonts
      vistafonts
    ];

    environment.systemPackages = with pkgs; [
      home-manager
      openconnect
      ventoy-bin
      exfatprogs
      exfat
    ];

    users.mutableUsers = true;
    documentation = {
      man.enable = true;
      dev.enable = true;
      nixos.enable = true;
    };

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
      hw.logitech-unifying.enable = true;
      virt = {
        docker.enable = true;
        libvirt = {
          enable = true;
          virt-manager.enable = true;
        };
      };
      net = {
        xrdp.enable = true;
        sshd.enable = true;
      };
      # infra-update = {
      #   enable = true;
      #   dates = "*-*-* 3:00:00 US/Pacific";
      # };
      xmonad.enable = true;
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
    };

    hardware.hackrf.enable = true;
    hardware.rtl-sdr.enable = true;
    services.sdrplayApi.enable = true;

    services.flatpak.enable = true;

    services.resolved = {
      enable = true;
      dnssec = "false";
      domains = ["~id.astrid.tech"];
    };
  };
}
