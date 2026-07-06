/**
  This module defines overlays.
*/
{ inputs, lib, ... }:
{
  _class = "flake";

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

    combined = lib.composeManyExtensions [
      patches
      astral
    ];

    default = combined;
  };
}
