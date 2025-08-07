{ nixpkgs-stable, ... }@inputs:
with nixpkgs-stable.lib;
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
in
rec {
  machines = collectMachines ./pc;

  nixosConfigurations =
    let
      enabledMachines = filterAttrs (_: m: m.machine-info.enable or true) machines;
      mkConfiguration =
        _: m:
        nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = m.machine-info.arch;
          modules = [ m.configuration ];
        };
    in
    mapAttrs mkConfiguration enabledMachines;
}
