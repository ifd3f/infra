{ config, pkgs, lib, ... }:
with lib; {
  networking.firewall.enable = mkForce false;

  networking.useDHCP = false; # DHCP not by default
  networking.interfaces.tmplan.useDHCP = true;

  networking.bridges = {
    tmplan.interfaces = [ "enp0s31f6" "sw.user" ];
    mgmt.interfaces = [ "sw.mgmt" ];
    iot.interfaces = [ "sw.iot" ];
    infra.interfaces = [ "sw.infra" ];
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

    "sw.iot" = {
      id = 100;
      interface = "enp3s0";
    };

    "sw.infra" = {
      id = 50;
      interface = "enp3s0";
    };
  };
}
