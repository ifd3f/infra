# A role representing a PC that I would directly use.
{ self, home-manager-stable, ... }:
let home-manager = home-manager-stable;
in { lib, pkgs, ... }: {
  imports = with self.nixosModules; [ cachix gnupg zsh ];

  nixpkgs.config.allowUnfree = true;

  # Trusted users for remote config builds and uploads
  nix.settings = {
    trusted-users = [ "root" "@wheel" ];
    auto-optimise-store = true;
  };

  environment.systemPackages = [
    home-manager.defaultPackage."x86_64-linux"

    pkgs.ntfs3g
    pkgs.openconnect
    pkgs.pciutils
    pkgs.pinentry
    pkgs.redshift
    pkgs.thunderbird
    pkgs.usbutils
    pkgs.wally-cli
    pkgs.xorg.xorgserver
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
