# Base configs for bare-metal servers.
{ self, ... }:
{
  imports = with self.nixosModules; [
    self.nixosModules.cachix
  ];

  # Trusted users for remote config builds and uploads
  nix.settings.trusted-users = [ "root" "@wheel" ];
  nix.settings.auto-optimise-store = true;

  # Enable SSH in initrd for debugging
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [ (import ../../ssh_keys).astrid ];
  };

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Operator users
  users.users.astrid = import ../users/astrid.nix;
}
