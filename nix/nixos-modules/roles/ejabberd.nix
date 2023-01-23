{ config, pkgs, lib, ... }:
with lib;
let
  httpPort = 5443;

  certDomains = [
    "xmpp.femboy.technology"
    "pubsub.xmpp.femboy.technology"
    "vjud.xmpp.femboy.technology"
    "conference.xmpp.femboy.technology"
  ];

  ejabberd-yml = {
    hosts = [ "ejabberd.femboy.technology" "xmpp.femboy.technology" ];
    certfiles = forEach certDomains
      (dn: config.security.acme.certs."${dn}".directory + "/*.pem");

    acl.admin = [{user = "ifd3f@xmpp.femboy.technology";}];

    access_rules = {
      configure.allow = "admin";
      webadmin_view.allow = "viewers";
    };

    modules = {
      mod_adhoc = { };
      mod_admin_extra = { };
      mod_configure = { };

      mod_announce.access = "admin";
      mod_avatar = { };
      mod_blocking = { };
      mod_bosh = { };
      mod_carboncopy = { };
      mod_disco = { name = "next-generation femboy technology"; };
      mod_last = { };
      mod_mam = {
        default = "always";
        user_mucsub_from_muc_archive = true;
      };
      mod_muc = { };
      mod_muc_admin = { };
      mod_muc_log = { };
      mod_offline = { };
      mod_ping = { };
      mod_pres_counter = { };
      mod_private = { };
      mod_privacy = { };
      mod_pubsub = { };
      mod_push = { };
      mod_roster = { };
      mod_time = { };
      mod_vcard = { search = true; };
      mod_vcard_xupdate = { };

      # TODO: mod_mqtt = { };
    };

    s2s_use_starttls = "required";

    listen = [
      {
        port = 5222;
        module = "ejabberd_c2s";
        starttls = true;
      }
      {
        port = 5269;
        module = "ejabberd_s2s_in";
        ip = "::";
      }
      {
        port = 5443;
        ip = "127.0.0.1";
        module = "ejabberd_http";
        tls = false; # We will use a reverse proxy
        request_handlers = {
          "/admin" = "ejabberd_web_admin";
        };
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

  security.acme.certs = mkMerge (forEach certDomains (dn: {
    "${dn}" = {
      group = "xmppcerts";
      reloadServices = [ "ejabberd.service" ];
    };
  }));

  services.nginx.virtualHosts = mkMerge (forEach certDomains (dn: {
    "${dn}" = {
      enableACME = true;
      addSSL = true;

      locations."/".extraConfig = ''
        rewrite ^/(.*)$ http://ejabberd.femboy.technology/$1 redirect;
      '';
    };
  }) ++ [{
    "ejabberd.femboy.technology" = {
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
  }]);

  networking.firewall.allowedTCPPorts = [ 5222 5269 ];

  users = {
    users = {
      ejabberd.extraGroups = [ "xmppcerts" ];
      nginx.extraGroups = [ "xmppcerts" ];
    };
    groups.xmppcerts = { };
  };
}
