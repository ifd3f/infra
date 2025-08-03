{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # If a more bleeding-edge feature or package is needed, we will import
    # it from unstable.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Machines run on nixpkgs-stable because it's less likely to break
    # in annoying ways.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    nur.url = "github:nix-community/NUR";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Specialized hardware configurations for specialized hardware.
    # Currently used on the Surface Pro.
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    {
      self,
      nixpkgs-stable,
      flake-utils,
      home-manager-stable,
      nur,
      ...
    }@inputs:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ]
      (
        system:
        let
          pkgs = import nixpkgs-stable {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        rec {
          devShells = import ./nix/shells.nix {
            inherit self;
            pkgs = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          };
        }
      );
}
