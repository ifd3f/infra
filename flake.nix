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

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Specialized hardware configurations for specialized hardware.
    # Currently used on the Surface Pro.
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    armqr = {
      url = "github:ifd3f/armqr";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs =
    {
      self,
      nixpkgs-stable,
      flake-parts,
      home-manager,
      nur,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          inputs.home-manager.flakeModules.home-manager

          ./nix/rescue
          ./nix/nixos/machines 
        ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];

        flake = {
          nixosModules = rec {
            astral = {
              imports = [ ./nix/nixos/modules ];
              astral.inputs.sshKeyDatabase = import ./ssh_keys;
            };
            default = astral;
          };
          homeConfigurations = {
            astrid = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs-stable { system = "x86_64-linux"; };
              modules = [ ./nix/home-manager/basic.nix ];
            };
          };
        };

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {
            devShells = import ./nix/shells.nix {
              inherit self;
              pkgs = import nixpkgs-stable {
                inherit system;
                config.allowUnfree = true;
              };
            };

            legacyPackages.helpers = pkgs.callPackage ./nix/helpers.nix { };
          };
      }
    );
}
