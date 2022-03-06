{ lib, ... }:
with lib; {
  options.astral.roles.bm-server = mkOption {
    description = "Bare metal server";
    default = false;
    type = types.bool;
  };

  config = {
    # Enable SSH in initrd for debugging
    boot.initrd.network.ssh = {
      enable = true;
      authorizedKeys = [ (import ../../ssh_keys).astrid ];
    };

    # Passwordless sudo
    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;

    astral.net.sshd.enable = true;
  };
}
