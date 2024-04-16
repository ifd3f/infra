{ pkgs, lib, ... }:
with lib;
let
  constants = import ./constants.nix;
  unaddressedNetwork = {
    DHCP = "no";
    IPv6AcceptRA = "no";
    IPv6SendRA = "no";
    LLDP = "no";
    EmitLLDP = "no";
    LinkLocalAddressing = "no";
  };
in {
  networking.useDHCP = false;
  networking.interfaces.${constants.mgmt_if}.useDHCP = true;
  networking.firewall.enable = mkForce false;

  systemd.network = {
    enable = true;

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
      networkConfig = unaddressedNetwork // {
        Description = "Bond of primary ethernet devices";
        VLAN = [ "bond007.100" ];
      };
    };

    netdevs."30-bond007-vlan100" = {
      netdevConfig = {
        Name = "bond007.100";
        Kind = "vlan";
        Description = "Public prod traffic VLAN";
      };
      vlanConfig.Id = 100;
    };
    networks."30-bond007-vlan100" = {
      name = "bond007.100";
      matchConfig.Type = "vlan";
      bridge = [ "prodbr" ];
      networkConfig = unaddressedNetwork // {
        Description = "VLAN of prod traffic over the bond";
      };
    };

    netdevs."40-prodbr" = {
      netdevConfig = {
        Name = "prodbr";
        Kind = "bridge";
      };
      extraConfig = ''
        [Bridge]
        STP = yes
      '';
    };
    networks."40-prodbr" = {
      name = "prodbr";
      matchConfig.Type = "bridge";
      networkConfig = unaddressedNetwork // {
        Description = "Bridge of prod traffic";
        ConfigureWithoutCarrier = "yes";
      };
    };

    netdevs."40-k8sbr" = {
      netdevConfig = {
        Name = "k8sbr";
        Kind = "bridge";
        Description = "Bridge for Kubernetes VMs";
      };
    };
    networks."40-k8sbr" = {
      name = "k8sbr";
      matchConfig.Type = "bridge";
      networkConfig = unaddressedNetwork // {
        Description = "Bridge for Kubernetes VMs";
      };
    };
  };
}
