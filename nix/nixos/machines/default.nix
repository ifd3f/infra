{
  self,
  inputs,
  lib,
  ...
}:
with lib;
let
  mkMachine = hostname: path: {
    inherit hostname path;
    readme = path + "/README.md";
    machine-info = import (path + "/machine-info.nix");
    configuration = import (path + "/configuration.nix");
  };

  collectMachines =
    dir:
    let
      subdirs = (
        filterAttrs (name: type: type == "directory" && pathExists ("${dir}/${name}/machine-info.nix")) (
          builtins.readDir dir
        )
      );
    in
    mapAttrs (hostname: _: mkMachine hostname ("${dir}/${hostname}")) subdirs;

  machines = collectMachines ./pc // collectMachines ./server;
in
rec {
  flake.nixosConfigurations =
    let
      enabledMachines = filterAttrs (_: m: m.machine-info.enable or true) machines;
      mkConfiguration =
        _: m:
        inputs.nixpkgs-stable.lib.nixosSystem {
          specialArgs.inputs = {
            inherit self;
            inherit (inputs) nixos-hardware armqr;
            nixpkgs = inputs.nixpkgs-stable;
            nixpkgs-unstable = inputs.nixpkgs-unstable;
          };
          system = m.machine-info.arch;
          modules = [
            self.nixosModules.default
            m.configuration
          ];
        };
    in
    mapAttrs mkConfiguration enabledMachines;
}
