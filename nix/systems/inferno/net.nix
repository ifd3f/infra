{ config, pkgs, lib, ... }:
with lib; {
  networking.firewall.enable = mkForce false;

  networking.useDHCP = false; # DHCP not by default
  networking.interfaces = {
    br-user.useDHCP = true;

    br-mgmt = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.69.4";
        prefixLength = 16;
      }];
    };
  };

  networking.bridges = {
    br-mb.interfaces = [ "enp0s31f6" ];
    br-swtrunk.interfaces = [ "enp3s0" ];

    br-user.interfaces = [ "sw.user" ];
    br-mgmt.interfaces = [ "sw.mgmt" ];
  };

  networking.vlans = {
    "sw.mgmt" = {
      id = 69;
      interface = "enp3s0";
    };

    "sw.user" = {
      id = 10;
      interface = "enp3s0";
    };
  };
}
