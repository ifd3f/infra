let constants = import ./constants.nix;
in {
  networking.useDHCP = false;
  networking.interfaces.${constants.mgmt_if}.useDHCP = true;

  systemd.network = {
    enable = true;

    netdevs."10-prod-vlan-100" = {
      netdevConfig = {
        Name = "prod-vlan";
        Kind = "vlan";
        Description = "Public prod traffic VLAN";
      };
      vlanConfig.Id = 100;
    };
    networks."10-bond-enos" = {
      name = "eno2 eno3 eno4";
      matchConfig.Type = "ether";
      networkConfig.Description = "Primary ethernet devices";
      bond = [ "bond007" ];
    };
    netdevs."20-bond007" = {
      netdevConfig = {
        Name = "bond007";
        Kind = "bond";
        Description = "Bond of primary ethernet devices";
      };
      bondConfig = {
        Mode = "802.3ad";
        LACPTransmitRate = "fast";
      };
    };
    networks."20-bond007" = {
      name = "bond007";
      matchConfig.Type = "bond";
      networkConfig = {
        Description = "Bond of primary ethernet devices";
        VLAN = [ "prod-vlan" ];
        LinkLocalAddressing = "no";
        LLDP = "no";
        IPv6AcceptRA = "no";
      };
    };
    networks."20-bond-prod-vlan" = {
      name = "prod-vlan";
      matchConfig.Type = "vlan";
      networkConfig.Description = "VLAN of prod traffic over the bond";
    };
  };
}
