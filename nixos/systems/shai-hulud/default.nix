# My Surface Pro.
{ nixos-hardware, ... }:
{ config, pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ]
    ++ (with nixos-hardware.nixosModules; [
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

    # so that we don't rebuild linux kernel on this tiny boi
    infra-update.branch = "surface";
  };

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  networking = {
    domain = "id.astrid.tech";

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

