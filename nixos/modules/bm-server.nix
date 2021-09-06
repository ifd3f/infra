# Base configs for bare-metal servers.

{ ... }:
{
  # Enable SSH in initrd for debugging
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [ (import ../keys.nix).astrid ];
  };

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Operator users
  users = {
    users = {
      astrid = import ../users/astrid.nix;
    };
  };
}
