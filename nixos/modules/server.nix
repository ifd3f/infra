{ config, pkgs, ... }:
{
  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;
}
