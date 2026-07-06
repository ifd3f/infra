{
  self,
  inputs,
  lib,
  ...
}:
with lib;
{
  _class = "flake";

  /**
    WARNING: These overlays MUST NOT depend on `self`. That is the route
    to annoying recursion errors.
  */
  flake.overlays = rec {
    /**
      This overlay adds custom resources under the `astral` namespace.
    */
    astral =
      final: prev:
      let
        system = final.stdenv.hostPlatform.system;
      in
      {
        astral = prev.astral // {
          armqr = inputs.armqr.packages.${system}.default;
          helpers = prev.callPackage ./helpers.nix { };
          nixowos-svg = ./nixowos.svg;
        };
      };

    /**
      This overlay replaces existing nixpkgs resources
    */
    patches =
      final: prev:
      let
        system = final.stdenv.hostPlatform.system;
      in
      {
        inherit (inputs.nixpkgs-unstable.legacyPackages.${system})
          # TODO: trilium is out of date on stable, remove when it's updated
          trilium
          trilium-server
          ;
      };

    /**
      This is the overlay used across this entire flake.
    */
    global = lib.composeManyExtensions [
      patches
      astral
    ];

    default = global;
  };

  perSystem =
    { config, system, ... }:
    {
      options.astral = {
        pkgs = mkOption {
          description = "Global `pkgs` object for ${system}";
          type = types.attrs;
        };
        basePkgs = mkOption {
          description = "`pkgs` object to overlay onto for ${system}";
          type = types.attrs;
        };
      };

      config._module.args.pkgs = config.astral.basePkgs.extend self.overlays.global;
    };
}
