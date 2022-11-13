{ pkgs, lib, config, ... }:
with lib; {
  options.astral.roles.auth-dns.enable =
    mkEnableOption "astral authoritative DNS";

  config = let cfg = config.astral.roles.auth-dns;
  in mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 53 ];

    # The BIND module sets this to true.
    # We don't want this because our auth DNS doesn't support recursion.
    networking.resolvconf.useLocalResolver = false;

    services.bind = {
      enable = true;

      # DNS hardening ideas borrowed from https://securitytrails.com/blog/8-tips-to-prevent-dns-attacks
      extraOptions = ''
        // Empty zones bad from what I've heard
        empty-zones-enable no;

        // Severe rate limits (we're an authoritative server)
        rate-limit {
          responses-per-second 5;
          window 5;
        };

        // Hide the DNS version
        version "YoMomma";

        // No zone transfers
        // TODO: allow it for specific servers when I make a secondary server
        allow-transfer {
          "none";
        };

        // Disallow recursion (we're an authoritative server)
        recursion no;
        allow-recursion {
          "localhost";
          "none";
        };
      '';

      extraConfig = ''
        zone "id.astrid.tech" {
          type forward;
          forward only;
          forwarders { 2a02:c207:2087:999:1::2; };
        };
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
