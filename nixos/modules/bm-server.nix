# Base configs for bare-metal servers.

{ config, pkgs, ... }:
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
