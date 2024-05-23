inputs:
{ config, pkgs, lib, ... }:
with lib; {
  imports = [ ./hardware-configuration.nix ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc-ssd
      microsoft-surface-common
    ]) ++ [
      inputs.self.nixosModules.laptop
      inputs.self.nixosModules.pc

      ./fs.nix
    ];

  microsoft-surface.kernelVersion = "6.8";
  microsoft-surface.ipts = {
    enable = true;
    config = {
      Config = {
        BlockOnPalm = true;
        TouchThreshold = 20;
        StabilityThreshold = 0.1;
      };
    };
  };

  time.timeZone = "US/Pacific";

  # so i can be a *gamer*
  programs.steam.enable = true;

  astral = {
    hw.surface.enable = true;
    xmonad.enable = true;

    tailscale = {
      enable = true;
      oneOffKey = "tskey-auth-kRbfM94CNTRL-cPfcJPJu5j9hifAP6gXzh92oaMd4hjvnV";
    };

    # so that we don't rebuild linux kernel on this tiny boi
    infra-update.branch = "surface";

    ci.needs = [ "surface-kernel" ];
  };

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  networking = {
    hostName = "shai-hulud";

    hostId = "49e32584";
    networkmanager.enable = true;
    useDHCP = false;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
      splashImage = ./shai-hulud-dark.jpg;
    };
  };

  services.xserver.dpi = 180;
}

