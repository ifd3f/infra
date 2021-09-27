# My old HP x360 Pavilion. It's lighter than BANANA, so I plan on bringing it to class.

{ self, nixpkgs-unstable, home-manager,... }:
let
  nixpkgs = nixpkgs-unstable;

  netModule = import ./net.nix;
  bootModule = import ./boot.nix;
  fs = import ./fs.nix;

  specialized = { config, lib, pkgs, ... }: {
    time.timeZone = "US/Pacific";

    ext4-ephroot.partition = fs.devices.rootPart;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.astrid = import ../../home-manager/astrid.nix;
    };

    users = {
      users = {
        astrid = import ../../users/astrid.nix;
      };
    };
  };

in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = with self.nixosModules; [
    ext4-ephroot
    debuggable
    libvirt
    stable-flake
    zfs-boot
    home-manager.nixosModules.home-manager

    bootModule
    fs.module
    netModule
    specialized
  ];
}
 