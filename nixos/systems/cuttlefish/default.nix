# The Raspberry Pi controlling my 3D printer via Octopi.
inputs:
let
  nixpkgs = inputs.nixpkgs-stable;
in nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";

  modules = [
    (import ./specialized.nix inputs)
  ];
}

