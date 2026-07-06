/**
  This file owns and defines all of the NixOS-related stuff.
*/
{
  self,
  lib,
  config,
  ...
}:
{
  _class = "flake";

  flake.nixosModules = rec {
    astral = ./astral;
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
          evaluated = config.astral.nixosSystem {
            specialArgs.self = self;
            specialArgs.nixos-hardware = config.astral.nixos-hardware;
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
    in
    self.lib.mergeAssertDisjoint (collectMachines ./machines/pc) (collectMachines ./machines/server);
}
