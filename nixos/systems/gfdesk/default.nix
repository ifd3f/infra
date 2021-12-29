# The desk that is used by Good Friends.
inputs:
let
  nixpkgs = inputs.nixpkgs-unstable;
  home-manager = inputs.home-manager-unstable;
in nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules =
    [ (import ./hardware-configuration.nix) (import ./specialized.nix inputs) ];
}
