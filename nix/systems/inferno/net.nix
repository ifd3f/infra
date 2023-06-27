{ config, pkgs, lib, ... }:
with lib; {
  networking.firewall.enable = mkForce false;

  networking.useDHCP = true;

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
