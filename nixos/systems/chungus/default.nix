# My gaming desktop.
{ ... }:
{ pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  time.timeZone = "US/Pacific";

  astral = { roles.pc.enable = true; };

  # so i can be a *gamer*
  programs.steam.enable = true;

  virtualisation.lxd.enable = true;

  # Nvidia configs, following this page https://nixos.wiki/wiki/Nvidia
  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  services.blueman.enable = true;

  hardware.opengl.enable = true;

  networking = {
    hostName = "chungus";
    domain = "id.astrid.tech";

    hostId = "b75842a7";
    networkmanager.enable = true;
    useDHCP = false;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;

    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        version = 2;
        useOSProber = true;
	# TODO pick a grub background
        # splashImage = ./banana-grub-bg-dark.jpg;
      };
    };
  };
}

