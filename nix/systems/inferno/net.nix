{ config, pkgs, lib, ... }:
with lib; {
  networking.firewall.enable = mkForce false;

  networking.useDHCP = false;
  networking.tempAddresses = "disabled";

  networking.defaultGateway = {
    address = "192.168.69.1";
    interface = "mgmtlink";
  };

  # Motherboard port, accessible for debugging purposes.
  networking.interfaces.enp0s31f6 = {
    useDHCP = true;
    ipv4.addresses = [{
      address = "172.16.69.1";
      prefixLength = 24;
    }];
    tempAddress = "enabled";
  };

  # This is connected to vlan 69, albeit indirectly.
  networking.bridges.mgmtlink.interfaces = [ ];
  networking.interfaces.mgmtlink = {
    ipv4.addresses = [{
      address = "192.168.69.10";
      prefixLength = 24;
    }];
    tempAddress = "disabled";
  };

  # These networking ports are directly attached to the firewall VM,
  # via macvtap devices.
  networking.interfaces.enp3s0.tempAddress = "disabled"; # switch trunk
  networking.interfaces.enp4s0.tempAddress = "disabled"; # WAN
}
