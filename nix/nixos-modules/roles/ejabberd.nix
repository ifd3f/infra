{ config, pkgs, lib, ... }:
let
  certbotcfg = config.security.acme.certs."xmpp.femboy.technology";

  httpPort = 5443;

  ejabberd-yml = {
    hosts = [ "xmpp.femboy.technology" ];
    acl.admin.user = [ "ifd3f@xmpp.femboy.technology" ];
    certfiles =
      [ "${certbotcfg.directory}/cert.pem" "${certbotcfg.directory}/key.pem" ];

    listen = [
      {
        port = 5222;
        module = "ejabberd_c2s";
        ip = "127.0.0.1";
        starttls = true;
      }
      {
        port = 5269;
        module = "ejabberd_s2s_in";
        transport = "tcp";
      }
      {
        port = 5443;
        ip = "127.0.0.1";
        module = "ejabberd_http";
        tls = true;
        request_handlers = { "/admin" = "ejabberd_web_admin"; };
      }
    ];
  };

in {
  astral = {
    custom-nginx-errors.virtualHosts = [ "xmpp.femboy.technology" ];
    backup.services.paths = [ config.services.ejabberd.spoolDir ];
  };

  services.ejabberd = {
    enable = true;
    configFile = pkgs.writeText "ejabberd.yml" (builtins.toJSON ejabberd-yml);
  };

  security.acme.certs."xmpp.femboy.technology".reloadServices =
    [ "ejabberd.service" ];

  networking.firewall.allowedTCPPorts = [ 5222 5269 ];

  services.nginx.virtualHosts."xmpp.femboy.technology" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString httpPort}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };
}
