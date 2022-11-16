# Contabo VPS.
{ pkgs, lib, inputs, ... }: {
  imports = [ inputs.self.nixosModules.oracle-cloud-vps ];

  astral = {
    ci.deploy-to = "192.9.153.114";
    roles.server.enable = true;
  };

  networking.hostName = "yato";

  time.timeZone = "US/Pacific";
}
