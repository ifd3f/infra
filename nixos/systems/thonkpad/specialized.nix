{ self, home-manager-unstable, ... }:
{ config, lib, pkgs, ... }: {
  imports = with self.nixosModules; [
    (import ./hardware-configuration.nix)

    bm-server
    debuggable
    flake-update
    home-manager-unstable.nixosModules.home-manager
    libvirt
    nix-dev
    sshd
    stable-flake
    zfs-boot
    zsh
  ];

  time.timeZone = "US/Pacific";

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    copyKernels = true;
  };

  networking = {
    hostName = "thonkpad";
    domain = "id.astrid.tech";
    hostId = "49e32584";
    
    useDHCP = false;
    interfaces.enp0s25.useDHCP = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # TODO refer to self.homeConfigurations."astrid@gfdesk" instead
    users.astrid = self.homeModules.astrid_cli_full;
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
    users.astrid = import ../../users/astrid.nix;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
