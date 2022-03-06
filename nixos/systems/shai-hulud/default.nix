# My Surface Pro.
{ nixos-hardware }:
{ config, pkgs, lib, ... }: {
  imports = (with self.nixosModules; [ ./hardware-configuration.nix ])
    ++ (with nixos-hardware.nixosModules; [
      common-cpu-intel
      common-pc-ssd
      microsoft-surface
    ]);
  time.timeZone = "US/Pacific";

  # so i can be a *gamer*
  programs.steam.enable = true;

  astral.roles.pc.enable = true;

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  networking = {
    domain = "id.astrid.tech";
    wireless.enable = true;

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

