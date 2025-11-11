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

    armqr = {
      url = "github:ifd3f/armqr";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # TMP(2025-11-06): zfs isn't stable on 6.17 yet so use the version before they updated
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon/7aad69158fc1b5bbbddac19040b6aae14daaa35c";
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

          packages = {
            installers = import ./nix/nixos/installers { inherit inputs system; };
          };
        };
    in
    systemAgnostic // flake-utils.lib.eachSystem supportedSystems perSystem;
}
