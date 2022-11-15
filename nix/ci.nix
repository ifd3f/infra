{ self, lib }:
with lib; {
  cronSchedule = "0 6 * * 6";

  cachix = "astralbijection";

  nodes = {
    "surface-kernel" = {
      build =
        "nixosConfigurations.shai-hulud.config.boot.kernelPackages.kernel";
    };

    "shai-hulud" = {
      needs = [ "surface-kernel" ];
      build = "nixosConfigurations.shai-hulud.config.system.build.toplevel";
    };
  };
}
