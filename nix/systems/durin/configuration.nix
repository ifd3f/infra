# Contabo VPS.
{ pkgs, lib, inputs, ... }: {
  imports = [
    inputs.self.nixosModules.oracle-cloud-vps
    inputs.self.nixosModules.server

    inputs.self.nixosModules.monitoring-center
  ];

  astral = {
    ci.deploy-to = "192.9.241.223";
  };

  networking = {
    hostName = "durin";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";
}
