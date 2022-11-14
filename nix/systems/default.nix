{ inputs, lib }:
let
  # Import every folder in this directory
  primarySystems = with lib.attrsets;
    (mapAttrs (dir: _: (import "${./.}/${dir}" inputs))
      (filterAttrs (_: type: type == "directory") (builtins.readDir ./.)));
in primarySystems // (import ./pi-jumpservers.nix inputs)
