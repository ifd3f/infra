# Contabo VPS.
{ pkgs, lib, inputs, ... }: {
  imports = [
    inputs.self.nixosModules.oracle-cloud-vps
    inputs.self.nixosModules.server

    inputs.self.nixosModules.vault
  ];

  astral = {
    ci.deploy-to = "192.9.153.114";
  };

  networking = {
    hostName = "yato";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";
}
