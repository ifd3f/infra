{ self, nixpkgs-stable, ... }@inputs:
let
  mkMachine = hostname: path: {
    inherit hostname path;
    readme = path + "/README.md";
    machine-info = import (path + "/machine-info.nix");
    configuration = import (path + "/configuration.nix") inputs;
  };

in
with nixpkgs-stable.lib;
rec {
  machines =
    let
      dirs = (
        filterAttrs (name: type: type == "directory" && pathExists (././${name}/machine-info.nix)) (
          builtins.readDir ./.
        )
      );
    in
    mapAttrs (hostname: _: mkMachine hostname (./. + "/${hostname}")) dirs;

  nixosConfigurations =
    let
      enabledMachines = filterAttrs (_: m: m.machine-info.enabled or true) machines;
      mkConfiguration =
        _: m:
        nixpkgs-stable.lib.nixosSystem {
          system = m.machine-info.arch;
          modules = [
            self.nixosModules.astral
            m.configuration
          ];
        };
    in
    mapAttrs mkConfiguration enabledMachines;
}
