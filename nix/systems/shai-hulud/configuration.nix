# My Surface Pro.
{ config, pkgs, lib, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-pc-ssd
      microsoft-surface
    ]);

  time.timeZone = "US/Pacific";

  # so i can be a *gamer*
  programs.steam.enable = true;

  astral = {
    roles = {
      laptop.enable = true;
      pc.enable = true;
    };
    hw.surface.enable = true;
    xmonad.enable = true;

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
      version = 2;
      useOSProber = true;
      splashImage = ./shai-hulud-dark.jpg;
    };
  };
}

