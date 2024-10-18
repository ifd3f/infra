inputs:
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    inputs.self.nixosModules.oracle-cloud-vps
    inputs.self.nixosModules.server

    inputs.self.nixosModules.vault
  ];

  astral = {
    ci.deploy-to = "192.9.153.114";
    tailscale.oneOffKey = "tskey-auth-kCfjRX3CNTRL-kx4uk1v9QCdsz6RMdS5wAd9J6czeFeuD";
    monitoring-node.scrapeTransport = "https";
  };

  networking = {
    hostName = "yato";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";
}
