# Contabo VPS.
{ pkgs, lib, inputs, ... }: {
  imports =
    [ ./hardware-configuration.nix inputs.self.nixosModules.contabo-vps ];

  astral = {
    ci.deploy-to = "154.53.59.80";
    roles = { server.enable = true; };
  };

  networking = {
    hostName = "bennett";
    interfaces.ens18.ipv6.addresses = [{
      address = "2605:a141:2108:6306::1";
      prefixLength = 64;
    }];
  };

  time.timeZone = "US/Pacific";
}
