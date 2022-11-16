{ self, lib }:
with lib;
let
  # Generate a node for each x86_64-linux NixOS system.
  nixosNodesForSystem = system:
    mapAttrs' (hostname: nixosSystem:
      let cfg = nixosSystem.config.astral.ci;
      in {
        name = "nixos-system-${hostname}";
        value = {
          inherit system;
          inherit (cfg) needs prune-runner;

          name = "NixOS sys. ${hostname}";
          build =
            "nixosConfigurations.${hostname}.config.system.build.toplevel";
          run = mapNullable
            (_: "nixosConfigurations.${hostname}.config.astral.ci.run-package")
            cfg.run-package;
          deploy = mapNullable (_:
            "nixosConfigurations.${hostname}.config.astral.ci.deploy-package")
            cfg.deploy-package;
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

in rec {
  ssh-deploy-targets = builtins.filter (x: x != null)
    (mapAttrsToList (_: system: system.config.astral.ci.deploy-to)
      self.nixosConfigurations);

  cronSchedule = "0 6 * * 6";

  cachix = "astralbijection";

  nodes = {
    installer-iso = {
      name = "x86 Installer ISO";
      system = "x86_64-linux";
      build = "packages.x86_64-linux.installer-iso";

      needs = [ "home-manager-x86_64-linux" ];
    };

    surface-kernel = {
      name = "Compile MS Surface kernel";
      system = "x86_64-linux";
      prune-runner = true;
      build =
        "nixosConfigurations.shai-hulud.config.boot.kernelPackages.kernel";
    };
  } // (foldAttrs mergeAttrs { } (builtins.map (system: {
    "devShells-${system}" = devShellNodeForSystem system;
    "home-manager-${system}" = homeManagerNodeForSystem system;
  }) [ "x86_64-linux" "x86_64-darwin" ]))
    // (nixosNodesForSystem "x86_64-linux");

  workflow = self.lib.makeGithubWorkflow { inherit cronSchedule cachix nodes; };
}
