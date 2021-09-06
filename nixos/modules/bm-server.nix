# Base configs for bare-metal servers.

{ ... }:
{
  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Operator users
  users = {
    users = {
      astrid = import ../users/astrid.nix;
    };
  };
}
