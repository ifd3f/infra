{ pkgs, lib, ... }:
with lib; {
  networking.firewall.allowedUDPPorts = [ 53 ];

  # The BIND module sets this to true.
  # We don't want this because our auth DNS doesn't support recursion.
  networking.resolvconf.useLocalResolver = false;

  services.bind = {
    enable = true;

    # DNS hardening ideas borrowed from https://securitytrails.com/blog/8-tips-to-prevent-dns-attacks
    extraOptions = ''
      // Make it listen on IPv6
      listen-on-v6 { any; };

      // Empty zones bad from what I've heard
      empty-zones-enable no;

      // Severe rate limits (we're an authoritative server)
      rate-limit {
        responses-per-second 20;
        window 20;
      };

      // Hide the DNS version
      version "YoMomma";

      // No zone transfers
      // TODO: allow it for specific servers when I make a secondary server
      allow-transfer {
        "none";
      };
    '';

    extraConfig = ''
      statistics-channels {
        inet 127.0.0.1 port 8053 allow { localhost; };
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

  services.prometheus.exporters.bind = {
    enable = true;
    bindURI = "http://localhost:8053/";
    bindGroups = [ "server" "view" "tasks" ];
  };

  # easter eggs
  services.nginx.virtualHosts =
    let hosts = [ "charlie" "dee" "dennis" "frank" "mac" ];
    in listToAttrs (map (host: {
      name = "${host}.astrid.tech";
      value = {
        enableACME = true;
        addSSL = true;
        root = ./placeholder-site;
        locations."/".index = "${host}.jpg";
      };
    }) hosts);
}
