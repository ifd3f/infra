# An old Thinkpad T420 to be used as a server.

{ self, nixpkgs-unstable, home-manager-unstable, ... }@inputs:
let
  nixpkgs = nixpkgs-unstable;
  home-manager = home-manager-unstable;
in nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [ (import ./specialized.nix inputs) ];
}

