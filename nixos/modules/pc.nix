# A role representing a PC that I would directly use.
{ self, home-manager-stable, ... }:
let home-manager = home-manager-stable;
in { lib, pkgs, ... }: {
  imports = with self.nixosModules; [ zsh ];

  nixpkgs.config.allowUnfree = true;
  # Trusted users for remote config builds and uploads
  nix.trustedUsers = [ "root" "@wheel" ];
  nix.autoOptimiseStore = true;

  environment.systemPackages = [
    home-manager.defaultPackage."x86_64-linux"
  ];

  users = {
    mutableUsers = true;

    users.astrid = import ../users/astrid.nix;
  };

  programs.zsh.enable = true;

  astral.program-sets.pc = true;
}
