{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # If a more bleeding-edge feature or package is needed, we will import
    # it from unstable.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Machines run on nixpkgs-stable because it's less likely to break
    # in annoying ways.
    # TMP(2025-11-10): put this on unstable in anticipation of 25.11
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Specialized hardware configurations for specialized hardware.
    # Currently used on the Surface Pro.
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    armqr = {
      url = "github:ifd3f/armqr";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
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
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      systemAgnostic = {
        nixosConfigurations = (import ./nix/nixos/machines inputs).nixosConfigurations;
      };

      perSystem =
        system:
        let
          pkgs = import nixpkgs-stable { inherit system; };
        in
        rec {
          devShells = import ./nix/shells.nix {
            inherit self;
            pkgs = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          };

          helpers = pkgs.callPackage ./nix/helpers.nix { };
        };
    in
    systemAgnostic // flake-utils.lib.eachSystem supportedSystems perSystem;
}
