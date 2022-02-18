{ self, ... }:
{ pkgs, lib, ... }: {
  imports = with self.nixosModules; [
    ./hardware-configuration.nix

    debuggable
    i3-kde
    laptop
    libvirt
    nix-dev
    office
    pc
    pipewire
    stable-flake
    wireguard-client
    zerotier
    zfs-boot
  ];
  time.timeZone = "US/Pacific";

  # so i can be a *gamer*
  programs.steam.enable = true;

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  networking = {
    hostName = "shai-hulud";
    domain = "id.astrid.tech";

    hostId = "49e32584";
    networkmanager.enable = true;
    useDHCP = false;
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        version = 2;
        useOSProber = true;
        splashImage = ./shai-hulud.jpg;
      };
    };
  };
}

