{ self, system ? "x86_64-linux" }:
let
  installerSystem = self.lib.nixosSystem {
    inherit system;
    modules = [ ./configuration.nix ];
  };
in installerSystem.config.system.build.isoImage
