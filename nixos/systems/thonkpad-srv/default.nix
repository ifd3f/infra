# My old HP x360 Pavilion. It's lighter than BANANA, so I plan on bringing it to class.

{ self, nixpkgs-unstable, home-manager-unstable, ... }:
let
  nixpkgs = nixpkgs-unstable;
  home-manager = home-manager-unstable;

  specialized = import ./specialized.nix;

in nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = with self.nixosModules; [
    debuggable
    i3-xfce
    libvirt
    pipewire
    stable-flake
    zfs-boot

    bootModule
    fs.module
    netModule
    specialized
    wireguard-client
  ];
}

