{ homeModules, self }:
{ config, lib, pkgs, ... }: {
  options.astral.roles.server.enable = lib.mkOption {
    description = "Some headless server that likely runs 24/7.";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.astral.roles.server.enable {
    # Use a stable, frozen-version hardened kernel
    boot.kernelPackages = pkgs.linuxPackages_5_15_hardened;

    # Enable SSH in initrd for debugging
    boot.initrd.network.ssh = {
      enable = true;
      authorizedKeys = [ self.lib.sshKeyDatabase.users.astrid ];
    };

    astral = {
      net.sshd.enable = true;
      infra-update.enable =
        false; # don't update automatically because everything's broken
      custom-tty.enable = true;

      users = {
        github.enable = true;
        terraform.enable = true;
      };

      ci.needs = [ "nixos-system-__baseServer" ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      # embed the home-manager into the configuration
      users.astrid = homeModules.astral-cli;
    };

    # Passwordless sudo
    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;
  };
}
