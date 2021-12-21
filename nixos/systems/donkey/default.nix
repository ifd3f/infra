# An ancient Dell Optiplex 360 I got off of eBay a few years ago for $40.
# It's called Donkey because it's slow, but I'll use it to hold data
# for me as a NAS.
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

