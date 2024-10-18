# Definitions for the bond and associated bridges/vlans.
let
  constants = import ../constants.nix;
  unaddressedNetwork = (import ./util.nix).unaddressedNetwork;

  bondname = "bond007";
  prodvlan = "bond007.100";
  prodbr = "prodbr";
in
{
  systemd.network = {
    networks."10-bond-enos" = {
      name = "eno2 eno3 eno4";
      matchConfig.Type = "ether";
      networkConfig.Description = "Primary ethernet devices";
      bond = [ bondname ];
    };

    netdevs."20-${bondname}" = {
      netdevConfig = {
        Name = bondname;
        Kind = "bond";
        Description = "Bond of primary ethernet devices";
      };
      bondConfig = {
        Mode = "802.3ad";
        LACPTransmitRate = "fast";
      };
    };
    networks."20-${bondname}" = {
      name = bondname;
      matchConfig.Type = "bond";
      networkConfig = unaddressedNetwork // {
        Description = "Bond of primary ethernet devices";
        VLAN = [ prodvlan ];
      };
    };

    netdevs."30-${prodvlan}" = {
      netdevConfig = {
        Name = prodvlan;
        Kind = "vlan";
        Description = "Public prod traffic VLAN";
      };
      vlanConfig.Id = 100;
    };
    networks."30-${prodvlan}" = {
      name = prodvlan;
      matchConfig.Type = "vlan";
      bridge = [ prodbr ];
      networkConfig = unaddressedNetwork // {
        Description = "VLAN of prod traffic over the bond";
      };
    };

    netdevs."40-${prodbr}" = {
      netdevConfig = {
        Name = prodbr;
        Kind = "bridge";
      };
      extraConfig = ''
        [Bridge]
        STP = yes
      '';
    };
    networks."40-${prodbr}" = {
      name = prodbr;
      matchConfig.Type = "bridge";
      networkConfig = unaddressedNetwork // {
        Description = "Bridge of prod traffic";
        ConfigureWithoutCarrier = "yes";
      };
    };
  };
}
