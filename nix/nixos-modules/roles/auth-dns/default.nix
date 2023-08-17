inputs:
{ config, pkgs, lib, ... }:
let
  vs = config.vault-secrets.secrets."ddns-key";
  binddir = config.services.bind.directory;
in with lib; {
  # vault kv put kv/ddns-key/secrets \
  #   s03=@
  vault-secrets.secrets."ddns-key" = { user = "named"; };

  networking.firewall.allowedUDPPorts = [ 53 ];

  # Disable resolvconf DNS
  networking.resolvconf.enable = mkForce false;

  # Statically set the resolver for local services to a public DNS
  environment.etc."resolv.conf".text = ''
    nameserver 1.1.1.1
    nameserver 8.8.4.4
    nameserver 8.8.8.8
  '';

  services.bind = {
    enable = true;

    cacheNetworks = mkForce [ "any" ];

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

      // Include s03 key file
      // include "${binddir}/s03.include.conf";
    '';

    zones = [
      {
        name = "astrid.tech";
        master = true;
        file = ./astrid.tech.zone;
      }
      {
        name = "d.astrid.tech";
        master = true;
        file = "d.astrid.tech.zone";
        extraConfig = ''
          allow-update { 
            key s03;
          };
        '';
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
      {
        name = "femboy.technology";
        master = true;
        file = ./femboy.technology.zone;
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

  systemd.services.generate-bind-key-includes = {
    description = "Generate config includes for BIND keys";

    # after = [ "ddns-key-secrets.service" ];
    # requires = [ "ddns-key-secrets.service" ];

    before = [ "bind.service" ];
    requiredBy = [ "bind.service" ];

    path = with pkgs; [ coreutils ];
    script = ''
      set -euxo pipefail

      secret="$(cat ${vs}/s03)"
      mkdir -p ${binddir}
      touch ${binddir}/s03.include.conf
      chmod 600 ${binddir}/s03.include.conf

      set +x # Prevent the secret from being echoed
      echo "
        key \"s03\" {
          algorithm hmac-sha256;
          secret \"$secret\";
        };
      " > ${binddir}/s03.include.conf
      set -x

      # Copy zone file if not exists
      cp -n ${./d.astrid.tech.zone} ${binddir}/d.astrid.tech.zone
    '';

    serviceConfig = { User = "named"; };
  };
}
