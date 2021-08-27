{ config, pkgs, ... }:
{
  time.timeZone = "US/Pacific";

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "yes";
    };
  };

  # TODO don't log in as root when NixOps 2.0 releases
  users = {
    users.root = {
      openssh.authorizedKeys.keys = [ (import ../keys.nix).astrid ];
    };
  };

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;
}