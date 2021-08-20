{ config, pkgs, ... }:
{
  imports = [
    "./sshd.nix"
  ];

  time.timeZone = "US/Pacific";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    neovim
    curl
  ];

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "yes";
    };
  };

  users = {
    mutableUsers = false;
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