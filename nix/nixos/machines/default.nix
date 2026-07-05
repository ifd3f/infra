{
  self,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.astral.machines;
in
{
  _class = "flake";

  options.astral.machines = with lib; {
    nixosSystem = mkOption {
      description = "Which nixpkgs.lib.nixosSystem implementation to use";
      type = types.functionTo (types.attrs);
    };
    nixos-hardware = mkOption {
      description = "Which nixos-hardware flake instance to use";
      type = types.attrs;
    };
  };

  config.flake.nixosConfigurations =
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
            specialArgs.inputs = {
              nixpkgs-unstable = inputs.nixpkgs-unstable;
            };
            specialArgs.nixos-hardware = cfg.nixos-hardware;
            modules = [
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
    mergeAssertDisjoint (collectMachines ./pc) (collectMachines ./server);
}
