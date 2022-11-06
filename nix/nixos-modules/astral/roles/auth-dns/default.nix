{ pkgs, lib, config, ... }:
with lib; {
  options.astral.roles.auth-dns.enable =
    mkEnableOption "astral authoritative DNS";

  config = let cfg = config.astral.roles.auth-dns;
  in mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 53 ];

    services.bind = {
      enable = true;

      extraOptions = ''
        empty-zones-enable no;
      '';

      zones = [
        {
          name = "astrid.tech";
          master = true;
          file = ./astrid.tech.zone;
        }
        {
          name = "aay.tw";
          master = true;
          file = ./aay.tw.zone;
        }
        {
          name = "0q4.org";
          master = true;
          file = ./0q4.org.zone;
        }
        {
          name = "astridyu.com";
          master = true;
          file = ./astridyu.com.zone;
        }
      ];
    };
  };
}
