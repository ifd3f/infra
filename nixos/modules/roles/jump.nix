{ config, lib, pkgs, ... }: with lib; {
  options.astral.roles.jump.enable = mkOption {
    description = "A standard jump server role";
    default = false;
    type = types.bool;
  };

  config = mkIf config.astral.roles.jump.enable {
    environment.systemPackages = [
      pkgs.wakelan # wake me up inside
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      # users.astrid = self.homeModules.astrid_cli_full;
    };
  };
}
