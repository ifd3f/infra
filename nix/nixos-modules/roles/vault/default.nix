{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.roles.vault;
  vcfg = config.services.vault;
in {
  services.vault = {
    enable = true;
    storageBackend = "file";
  };

  # Sure, it's a bit on the nose, but whatever.
  services.nginx.virtualHosts."secrets.astrid.tech" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = { proxyPass = "http://${vcfg.address}"; };
  };

  environment.systemPackages = with pkgs; [ vault ];
}
