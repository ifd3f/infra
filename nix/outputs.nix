{
  self,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager

    ./rescue
    ./nixos/machines
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  astral = {
    machines = {
      nixosSystem = inputs.nixpkgs-stable.lib.nixosSystem;
      nixos-hardware = inputs.nixos-hardware;
      overlay = self.overlays.default;
    };
  };

  flake.overlays.default = final: prev: {
    astral.resources = {
      nixowos-svg = ./nixowos.svg;
    };

    astral.helpers = prev.callPackage ./helpers.nix { };

    inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system})
      # TODO: trilium is out of date on stable, remove when it's updated
      trilium
      trilium-server
      ;
  };

  flake.nixosModules = rec {
    astral = { pkgs, lib, ... }: {
      imports = [ ./nixos/modules ];
      astral.inputs.sshKeyDatabase = import ../ssh_keys;
      services.armqr.package = lib.mkDefault inputs.armqr.packages.${pkgs.system}.default;
    };
    default = astral;
  };

  flake.homeConfigurations = {
    astrid = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs-stable { system = "x86_64-linux"; };
      modules = [ ./home-manager/basic.nix ];
    };
  };

  perSystem =
    { pkgs, system, ... }:
    {
      devShells = import ./shells.nix {
        inherit self;
        pkgs = import inputs.nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
}
