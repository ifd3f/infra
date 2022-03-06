# A role representing a PC that I would directly use.
{ self, home-manager-stable, ... }:
let home-manager = home-manager-stable;
in { lib, pkgs, ... }: {
  imports = with self.nixosModules; [ zsh ];

  environment.systemPackages = [
    home-manager.defaultPackage."x86_64-linux"
  ];

  users.mutableUsers = true;

  astral.program-sets.pc = true;
}
