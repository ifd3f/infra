{ config, lib, ... }:
with lib; {
  options.astral.roles.server.enable = mkOption {
    description = "Bare metal server";
    default = false;
    type = types.bool;
  };

  config = mkIf config.astral.roles.server.enable {
    # Enable SSH in initrd for debugging
    boot.initrd.network.ssh = {
      enable = true;
      authorizedKeys = [ (import ../../ssh_keys).astrid ];
    };

    # Passwordless sudo
    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;

    astral = {
      net.sshd.enable = true;
      infra-update.enable = true;
    };
  };
}
