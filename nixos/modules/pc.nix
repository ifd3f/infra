# A role representing a PC that I would directly use.
{ self, home-manager-stable, ... }:
let 
  home-manager = home-manager-stable;
in
{ lib, pkgs, ... }: {
  imports = with self.nixosModules; [
    cachix
    zsh
  ];

  nixpkgs.config.allowUnfree = true;
  nix.autoOptimiseStore = true;

  environment.systemPackages = [
    home-manager.defaultPackage."x86_64-linux"

    pkgs.ntfs3g
    pkgs.pciutils
    pkgs.redshift
    pkgs.thunderbird
    pkgs.usbutils
    pkgs.wally-cli
    pkgs.xorg.xorgserver
    pkgs.pinentry
  ];

  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };

  users = {
    mutableUsers = true;

    users.astrid = import ../users/astrid.nix;
  };

  programs = {
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "curses";
    };
  };

  # For flashing Ergodoxes
  hardware.keyboard.zsa.enable = true;
}
