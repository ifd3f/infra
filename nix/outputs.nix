{ self, inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager

    ./inputs.nix
    ./rescue
    ../nixos
    ./overlays.nix
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

      devShells = import ./shells.nix {
        inherit self;
        pkgs = import inputs.nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };

  flake.homeConfigurations = {
    astrid = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs-stable { system = "x86_64-linux"; };
      modules = [ ../home-manager/basic.nix ];
    };
  };
}
