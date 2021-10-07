# My old HP x360 Pavilion. It's lighter than BANANA, so I plan on bringing it to class.

{ self, nixpkgs-unstable, home-manager-unstable, ... }:
let
  nixpkgs = nixpkgs-unstable;
  home-manager = home-manager-unstable;

  netModule = import ./net.nix;
  bootModule = import ./boot.nix;
  fs = import ./fs.nix;

  specialized = { config, lib, pkgs, ... }: {
    time.timeZone = "US/Pacific";

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [
      pkgs.xorg.xorgserver
      pkgs.xorg.xf86videointel
      pkgs.xorg.xf86inputsynaptics
      home-manager.defaultPackage."x86_64-linux"
      pkgs.thunderbird
    ];

    services.geoclue2 = {
      enable = true;
      enableWifi = true;
    };

    users = {
      mutableUsers = true;

      users = { astrid = import ../../users/astrid.nix; };
    };

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  };

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
  ];
}

