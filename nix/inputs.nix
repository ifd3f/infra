/**
  This module defines the set of inputs we depend on.

  Ideally, no modules except for the main flake.nix and overlays.nix read the
  `inputs` argument at all. This rule is used to ensure we don't have implicit dependencies.
*/
{
  self,
  config,
  lib,
  ...
}:
with lib;
{
  _class = "flake";

  options.astral = {
    nixosSystem = mkOption {
      description = "Which `nixpkgs.lib.nixosSystem` implementation to use";
      type = with types; functionTo attrs;
    };
    nixos-hardware = mkOption {
      description = "Which nixos-hardware flake instance to use";
      type = types.attrs;
    };
  };
}
