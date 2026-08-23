/**
  This file owns and defines most of the NixOS-related stuff.
*/
{
  self,
  inputs,
  lib,
  config,
  ...
}:
{
  _class = "flake";

  imports = [ ./checks.nix ];

  flake.nixosModules = rec {
    astral = {
      imports = [
        self.nixosModules.pkgsets
        ./astral
      ];
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
          evaluated = config.astral.nixosSystem {
            specialArgs.self = self;

            # these provide modules that are enabled upon import so they go in specialArgs
            specialArgs.nixos-hardware = config.astral.nixos-hardware;
            specialArgs.microvm = config.astral.microvm;

            modules = [
              { nixpkgs.overlays = [ self.overlays.default ]; }

              # this must be enabled with services.flatpak.enable, so fine to add in here
              inputs.nix-flatpak.nixosModules.nix-flatpak

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
