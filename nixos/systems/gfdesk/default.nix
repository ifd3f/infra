# A chonky HP DL380P Gen8 rack server.

{ self, nixpkgs-unstable, home-manager-unstable, ... }:
let
  nixpkgs = nixpkgs-unstable;
  home-manager = home-manager-unstable;

  fs = import ./fs.nix;
  netModule = import ./net.nix;
  bootModule = import ./boot.nix;

  specialized = { config, lib, pkgs, ... }: {
    time.timeZone = "US/Pacific";

    ext4-ephroot.partition = fs.devices.rootPart;

    # Explicitly don't reboot on kernel upgrade. This server takes forever to reboot, plus 
    # it's a jet engine when it boots and it will probably wake me up at 4:00 AM
    system.autoUpgrade.allowReboot = false;

    # The Minecraft server port
    networking.firewall.allowedTCPPorts = [ 25565 ];

    users.users.alia = import ../../users/alia.nix;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      # TODO refer to self.homeConfigurations."astrid@gfdesk" instead
      users.astrid = self.homeModules.astrid_cli_full;
    };
  };

in nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = with self.nixosModules; [
    bm-server
    debuggable
    ext4-ephroot
    flake-update
    home-manager.nixosModules.home-manager
    libvirt
    nix-dev
    persistence
    sshd
    stable-flake
    zfs-boot
    zsh

    bootModule
    fs.module
    netModule
    specialized
  ];
}