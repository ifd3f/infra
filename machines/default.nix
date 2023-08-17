# Import every non-blacklisted folder in this directory
{ self, nixpkgs-stable, ... }@inputs:
let
  blacklist = [ "amiya" "bennett" "bonney" "ghoti" ];

  mkMachine = hostname: path: {
    inherit hostname path;
    readme = path + "/README.md";
    machine-info = import (path + "/machine-info.nix");
    configuration = import (path + "/configuration.nix") inputs;
  };

in with nixpkgs-stable.lib; rec {
  machines = let
    dirs = (filterAttrs
      (name: type: type == "directory" && !builtins.elem name blacklist)
      (builtins.readDir ./.));
  in mapAttrs (hostname: _: mkMachine hostname (./. + "/${hostname}")) dirs;

  nixosConfigurations = mapAttrs (_: data:
    nixpkgs-stable.lib.nixosSystem {
      system = data.machine-info.arch;
      modules = [ self.nixosModules.astral data.configuration ];
    }) machines;
}
