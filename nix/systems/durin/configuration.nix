# Contabo VPS.
{ pkgs, lib, inputs, ... }: {
  imports = [
    inputs.self.nixosModules.oracle-cloud-vps
    inputs.self.nixosModules.server
  ];

  astral = {
    ci.deploy-to = "192.9.241.223";
    monitoring.center.enable = true;
  };

  networking = {
    hostName = "durin";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";
}
