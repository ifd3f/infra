# A role representing a PC that I would directly use.
{ self, home-manager-stable, ... }:
let 
  home-manager = home-manager-stable;
in
{ lib, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.xorg.xorgserver
    home-manager.defaultPackage."x86_64-linux"
    pkgs.thunderbird
    pkgs.wally-cli
  ];

  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };

  users = {
    mutableUsers = true;

    users.astrid = import ../users/astrid.nix;
  };

  programs.zsh.enable = true;

  # For flashing Ergodoxes
  hardware.keyboard.zsa.enable = true;
}
