{ self, config, ... }: {
  _class = "flake";

  perSystem =
    { system, ... }:
    let
      /**
        Generate a fake NixOS system for testing against.
        Comes with convenience flags already pre-enabled.
      */
      fakeNixosSystem =
        module:
        config.astral.nixosSystem {
          inherit system;
          modules = [
            self.nixosModules.default
            module
            {
              nixpkgs.overlays = [ self.overlays.default ];
              networking.hostId = "00000000";
              boot.loader.grub.enable = false;
              fileSystems."/" = {
                fsType = "ext4";
                device = "/dev/sda";
              };
            }
          ];
        };
    in
    {
      checks = {
        astralNixosModuleWorksStandalone =
          (fakeNixosSystem {
          }).config.system.build.toplevel;

        astralNixosModuleWorksStandalonePc =
          (fakeNixosSystem {
            astral.roles.pc.enable = true;
          }).config.system.build.toplevel;

        astralNixosModuleWorksStandaloneServer =
          (fakeNixosSystem {
            astral.roles.server.enable = true;
          }).config.system.build.toplevel;
      };
    };
}
