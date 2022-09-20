{ homeModules, self }:
{ config, lib, ... }: {
  options.astral.roles.server.enable = lib.mkOption {
    description = "Bare metal server";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.astral.roles.server.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

    astral = {
      net.sshd.enable = true;
      infra-update.enable =
        false; # don't update automatically because everything's broken
    };

    # Enable SSH in initrd for debugging
    boot.initrd.network.ssh = {
      enable = true;
      authorizedKeys = [ self.lib.sshKeyDatabase.users.astrid ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.astrid = homeModules.astral-cli;
    };

    # Passwordless sudo
    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;
  };
}
