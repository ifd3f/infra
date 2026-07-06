/**
  This file owns and defines all of the NixOS-related stuff.
*/
{
  self,
  lib,
  config,
  ...
}:
let
  cfg = config.astral;
in
{
  _class = "flake";

  flake.nixosModules = rec {
    astral = { pkgs, lib, ... }: {
      imports = [ ./astral ];
      astral.inputs.sshKeyDatabase = import ../ssh_keys;
    };
    default = astral;
  };

  flake.nixosConfigurations =
    with lib;
    let
      /**
        convert the given module into a nixos configuration, and perform assertions
      */
      evalNixosSystem =
        dirname: module:
        let
          evaluated = cfg.nixosSystem {
            specialArgs.self = self;
            specialArgs.nixos-hardware = cfg.nixos-hardware;
            modules = [
              { nixpkgs.overlays = [ self.overlays.default ]; }
              self.nixosModules.default
              module
            ];
          };
        in
        assert assertMsg (
          evaluated.config.networking.hostName == dirname
        ) "hostname does not match directory name";
        evaluated;

      /**
        eval all the direct children of a directory
      */
      collectMachines =
        dir:
        mapAttrs (dirname: _: evalNixosSystem dirname "${dir}/${dirname}") (
          filterAttrs (name: type: type == "directory") (readDir dir)
        );

      /**
        assert that the two attrsets provided are disjoint, then merge them together.
        if they are not disjoint, this crashes.
      */
      mergeAssertDisjoint =
        a: b:
        let
          intersectingNames = attrNames (intersectAttrs a b);
        in
        assert assertMsg (
          length intersectingNames == 0
        ) "intersecting attr keys: ${toString intersectingNames}";
        a // b;

    in
    mergeAssertDisjoint (collectMachines ./machines/pc) (collectMachines ./machines/server);
}
