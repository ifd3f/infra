# Contabo VPS.
{ pkgs, lib, inputs, ... }: {
  imports = [ inputs.self.nixosModules.oracle-cloud-vps ];

  astral = {
    ci.deploy-to = "192.9.241.223";
    roles.server.enable = true;
  };

  networking.hostName = "durin";

  time.timeZone = "US/Pacific";
}
