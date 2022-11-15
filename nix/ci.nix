{ self, lib }:
with lib; {
  cronSchedule = "0 6 * * 6";

  cachix = "astralbijection";

  nodes = let
    # Generate a node for each x86_64-linux NixOS system.
    nixosNodesForSystem = system:
      mapAttrs' (hostname: nixosSystem: {
        name = "nixos-system-${hostname}";
        value = {
          inherit system;
          name = "NixOS sys. ${hostname}";
          build =
            "nixosConfigurations.${hostname}.config.system.build.toplevel";
          needs = nixosSystem.config.astral.ci.needs;
        };
      }) (filterAttrs (hostname: nixosSystem: nixosSystem.pkgs.system == system)
        self.nixosConfigurations);

    homeManagerNodeForSystem = system: {
      inherit system;

      name = "Home cfgs. ${system}";
      build =
        mapAttrsToList (key: _: "homeConfigurations.${key}.activationPackage")
        (filterAttrs (_: home: home.pkgs.system == system)
          self.homeConfigurations);
    };
  in {
    "home-manager_x86_64-linux" = homeManagerNodeForSystem "x86_64-linux";
    "home-manager_x86_64-darwin" = homeManagerNodeForSystem "x86_64-darwin";

    "surface-kernel" = {
      name = "Surface Kernel";
      system = "x86_64-linux";
      build =
        "nixosConfigurations.shai-hulud.config.boot.kernelPackages.kernel";
    };
  } // (nixosNodesForSystem "x86_64-linux");
}
