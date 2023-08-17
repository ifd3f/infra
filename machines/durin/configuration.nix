inputs:
{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    inputs.self.nixosModules.oracle-cloud-vps
    inputs.self.nixosModules.server

    inputs.self.nixosModules.monitoring-center
  ];

  astral = {
    ci.deploy-to = "192.9.241.223";
    tailscale.oneOffKey =
      "tskey-auth-kc9Bdo5CNTRL-mF1eQASE3L1p6CwLorXdJ1aZYCwBy8raR";
    monitoring-node.scrapeTransport = "https";
  };

  networking = {
    hostName = "durin";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";
}
