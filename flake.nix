{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    # If a more bleeding-edge feature or package is needed, we will import
    # it from unstable.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Machines run on nixpkgs-stable because it's less likely to break
    # in annoying ways.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    nur.url = "github:nix-community/NUR";

    # Specialized hardware configurations for specialized hardware.
    # Currently used on the Surface Pro.
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    armqr = {
      url = "github:ifd3f/armqr";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, lib, ... }:
      {
        imports = [
          ./nixos
          ./nix/inputs.nix
          ./nix/overlays.nix
          ./pkgs
          ./nix/shells.nix
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
        };

        perSystem = { inputs', ... }: { astral.basePkgs = inputs'.nixpkgs-stable.legacyPackages; };

        flake.lib = import ./nix/lib { inherit lib; };
      }
    );

}
