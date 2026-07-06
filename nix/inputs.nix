/**
  This module defines the set of inputs we depend on.

  Ideally, no modules except for the main flake.nix file read the `inputs` argument at all.
  This rule is used to ensure we don't have implicit dependencies.
*/
{ config, lib, ... }:
with lib;
let
  selectedOverlay = config.astral.overlay;
in
{
  _class = "flake";

  options.astral = {
    overlay = mkOption {
      description = "Package overlay to apply onto everything";
      type = with types; functionTo (functionTo attrs);
    };
    nixosSystem = mkOption {
      description = "Which `nixpkgs.lib.nixosSystem` implementation to use";
      type = with types; functionTo attrs;
    };
    nixos-hardware = mkOption {
      description = "Which nixos-hardware flake instance to use";
      type = types.attrs;
    };
  };

  config.perSystem =
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

      config.astral.pkgs = config.astral.basePkgs.extend selectedOverlay;
    };
}
