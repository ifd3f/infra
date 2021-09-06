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

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;
}
