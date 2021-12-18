# My gaming laptop.
inputs:
let
  nixpkgs = inputs.nixpkgs-unstable;
  home-manager = inputs.home-manager-unstable;
in nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [
    (import ./specialized.nix inputs)
  ];
}
