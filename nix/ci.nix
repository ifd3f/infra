{ self, lib }:
with lib; {
  cronSchedule = "0 6 * * 6";

  cachix = "astralbijection";

  nodes = let
    # Generate a node for each x86_64-linux NixOS system.
    x86SystemNodes = mapAttrs' (hostname: system: {
      name = "nixos-system-${hostname}";
      value = {
        build =
          "nixosConfigurations.${hostname}.config.system.build.toplevel";
        needs = system.config.astral.ci.needs;
      };
    }) (filterAttrs (_: config: config.pkgs.system == "x86_64-linux")
      self.nixosConfigurations);

  in {
    "surface-kernel" = {
      build =
        "nixosConfigurations.shai-hulud.config.boot.kernelPackages.kernel";
    };
  } // x86SystemNodes;
}
