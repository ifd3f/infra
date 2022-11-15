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

    devShellNodeForSystem = system: {
      inherit system;

      name = "DevShells ${system}";
      build = mapAttrsToList (key: _: "devShells.${system}.${key}")
        self.devShells.${system};
    };
  in {
    installer-iso = {
      name = "x86 Installer ISO";
      system = "x86_64-linux";
      build = "packages.x86_64-linux.installer-iso";

      needs = [ "nixos-system-__base" "home-manager-x86_64-linux" ];
    };

    surface-kernel = {
      name = "Surface Kernel";
      system = "x86_64-linux";
      build =
        "nixosConfigurations.shai-hulud.config.boot.kernelPackages.kernel";
    };
  } // (foldAttrs mergeAttrs { } (builtins.map (system: {
    "devShells-${system}" = devShellNodeForSystem system;
    "home-manager-${system}" = homeManagerNodeForSystem system;
  }) [ "x86_64-linux" "x86_64-darwin" ]))
  // (nixosNodesForSystem "x86_64-linux");
}
