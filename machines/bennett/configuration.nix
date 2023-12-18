inputs:
{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix

    inputs.self.nixosModules.contabo-vps
    inputs.self.nixosModules.server
  ];

  astral = {
    ci.enable = mkForce false;
    monitoring-node.enable = mkForce false;
    # ci.deploy-to = "154.53.59.80";
  };

  networking = {
    hostName = "bennett";
    domain = "h.astrid.tech";
    interfaces.ens18.ipv6.addresses = [{
      address = "2605:a141:2108:6306::1";
      prefixLength = 64;
    }];
  };

  time.timeZone = "US/Pacific";
}
