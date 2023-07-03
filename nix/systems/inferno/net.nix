{ config, pkgs, lib, ... }:
with lib; {
  networking.firewall.enable = mkForce false;

  networking.useDHCP = false; # DHCP not by default

  # Motherboard port, accessible for debugging purposes.
  networking.interfaces.enp0s31f6 = {
    useDHCP = true;
    tempAddress = "enabled";
  };

  # This is connected to vlan 69, albeit indirectly.
  networking.interfaces.mgmtlink = {
    virtual = true;
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
