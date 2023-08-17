{ self, nixpkgs, system ? "x86_64-linux" }:
let
  installerSystem = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [ (import ./configuration.nix self) ];
  };
in installerSystem.config.system.build.isoImage
