{ pkgs, lib, ... }:
with lib;
let
  constants = import ../constants.nix;
  unaddressedNetwork = (import ./util.nix).unaddressedNetwork;
in
{
  imports = [
    ./bond.nix
    ./k8s.nix
  ];

  networking.useDHCP = false;
  networking.interfaces.${constants.mgmt_if}.useDHCP = true;
  networking.firewall.enable = mkForce false;

  systemd.network = {
    enable = true;
  };
}
