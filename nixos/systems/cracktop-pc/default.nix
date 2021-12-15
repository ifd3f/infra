# My old HP x360 Pavilion. It's lighter than BANANA, so I plan on bringing it to class.

{ self, nixpkgs-unstable, home-manager-unstable, ... }:
let
  nixpkgs = nixpkgs-unstable;
  home-manager = home-manager-unstable;

  netModule = import ./net.nix;
  bootModule = import ./boot.nix;
  fs = import ./fs.nix;

  specialized = { 
    imports = with self.nixosModules; [
      debuggable
      i3-xfce
      laptop
      libvirt
      office
      pc
      pipewire
      stable-flake
      wireguard-client
      zfs-boot
    ];
    time.timeZone = "US/Pacific";
  };

in nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [
    bootModule
    fs.module
    netModule
    specialized
  ];
}

