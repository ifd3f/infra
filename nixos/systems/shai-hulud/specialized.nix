{ self, nixos-hardware, ... }:
{ pkgs, lib, ... }: {
  imports = (with self.nixosModules; [
    ./hardware-configuration.nix

    #surface-pro6
    debuggable
    i3-kde
    laptop
    libvirt
    nix-dev
    office
    pc
    pipewire
    qmk-udev
    stable-flake
    sshd
    wireguard-client
    zerotier
    zfs-boot
  ]) ++ (with nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-ssd
    microsoft-surface
  ]);
  time.timeZone = "US/Pacific";

  # see surface-pro6.nix
  #ptw.hardware.surface.enable = true;

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
        splashImage = ./shai-hulud-dark.jpg;
      };
    };
  };
}

