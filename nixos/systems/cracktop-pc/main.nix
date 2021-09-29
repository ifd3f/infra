# My old HP x360 Pavilion. It's lighter than BANANA, so I plan on bringing it to class.

{ self, nixpkgs-stable, home-manager, ... }:
let
  nixpkgs = nixpkgs-stable;

  netModule = import ./net.nix;
  bootModule = import ./boot.nix;
  fs = import ./fs.nix;

  specialized = { config, lib, pkgs, ... }: {
    time.timeZone = "US/Pacific";

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      xorg.xorgserver
      xorg.xf86videointel
      xorg.xf86inputsynaptics
    ];

    services.geoclue2 = {
      enable = true;
      enableWifi = true;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.astrid = import ../../home-manager/astrid_x11.nix;
    };

    users = {
      mutableUsers = true;

      users = {
        astrid = import ../../users/astrid.nix;
      };
    };

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  };

in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = with self.nixosModules; [
    debuggable
    home-manager.nixosModules.home-manager
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
 