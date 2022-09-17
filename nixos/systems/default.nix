{ self, nixpkgs, lib }:
let
  # Import every folder in this directory
  primarySystems = with lib.attrsets;
    (mapAttrs (dir: _: (import "${./.}/${dir}" { inherit self; }))
      (filterAttrs (_: type: type == "directory") (builtins.readDir ./.)));
in primarySystems // (import ./pi-jumpservers.nix { inherit self nixpkgs; })
