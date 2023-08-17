# Import every non-blacklisted folder in this directory
{ self, nixpkgs-stable, ... }@inputs:
let blacklist = [ "amiya" "bennett" "bonney" "ghoti" ];
in with nixpkgs-stable.lib; rec {
  systems = let
    dirs = (filterAttrs
      (name: type: type == "directory" && !builtins.elem name blacklist)
      (builtins.readDir ./.));
  in mapAttrs (dir: _: {
    hostname = dir;
    machine-info = import "${./.}/${dir}/machine-info.nix";
    configuration = import "${./.}/${dir}/configuration.nix" inputs;
  }) dirs;

  nixosConfigurations = mapAttrs (_: data:
    nixpkgs-stable.lib.nixosSystem {
      system = data.machine-info.arch;
      modules = [ self.nixosModules.astral data.configuration ];
    }) systems;
}
