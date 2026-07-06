{ self, inputs, ... }:
{
  imports = [
    ./inputs.nix
    ./rescue
    ../nixos
    ./overlays.nix
    ./shells.nix
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  astral = {
    nixosSystem = inputs.nixpkgs-stable.lib.nixosSystem;
    nixos-hardware = inputs.nixos-hardware;
    overlay = self.overlays.default;
  };

  perSystem =
    { inputs', system, ... }:
    {
      astral.basePkgs = inputs'.nixpkgs-stable.legacyPackages;
    };
}
