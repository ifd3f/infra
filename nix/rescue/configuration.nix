{
  lib,
  pkgs,
  modulesPath,
  ...
}:
with lib;
{
  # TODO: stop repreating so much shit
  _class = "nixos";

  imports = [
  ];

  users.mutableUsers = false;

  users.users.astrid = {
    isNormalUser = true;
    group = "astrid";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEl4yuE1X4IqjBqt/enMyZFZKJQLxeq34BTCNqey59aZ astrid@chungus"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3JIveqKo7ld4F/f+kR0n862Thm42cXrP3daFzyH2rW astrid@nyacbook-nyair.lan"
    ];
  };
  users.groups.astrid = {};

  # networking.supplicant."wlan0".configFile.path = "/wpa_supplicant.conf";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  environment.systemPackages = with pkgs; [
    fio
  ];
}
