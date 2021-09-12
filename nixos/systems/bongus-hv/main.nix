# A chonky HP DL380P Gen8 rack server.

{ self, nixpkgs-unstable, ... }:
let
  nixpkgs = nixpkgs-unstable;

  fs = import ./fs.nix;
  netModule = import ./net.nix;
  bootModule = import ./boot.nix;

  specialized = { config, lib, pkgs, ... }: {
    time.timeZone = "US/Pacific";

    ext4-ephroot.partition = fs.devices.rootPart;

    # Explicitly don't reboot on kernel upgrade. This server takes forever to reboot, plus 
    # it's a jet engine when it boots and it will probably wake me up at 4:00 AM
    system.autoUpgrade.allowReboot = false;
  };

in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = with self.nixosModules; [
    ext4-ephroot
    debuggable
    libvirt
    sshd
    bm-server
    stable-flake
    zfs-boot
    flake-update

    bootModule
    fs.module
    netModule
    specialized
  ];
}
 