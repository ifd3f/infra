# Base configs for bare-metal servers.
{ self, ... }:
{
  # Enable SSH in initrd for debugging
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [ (import ../../ssh_keys).astrid ];
  };

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  users.mutableUsers = false;
}
