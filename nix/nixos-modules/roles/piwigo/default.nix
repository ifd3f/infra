{ config, pkgs, ... }:
let
  piwigo = pkgs.fetchFromGitHub {
    owner = "Piwigo";
    repo = "Piwigo";
    rev = "13.6.0";
    hash = "sha256-FWWUMXIb+H0S4aiQ30fr/BobNwmQCwvLBmd0sPnkVlQ=";
  };

  webroot = "/var/www/photos";
in {
  systemd.services.piwigo-config = {
    description = "Copy Piwigo source code to directory";
    after = [ "network-online.target" ];
    wantedBy = [ "phpfpm-piwigo-pool.service" ];
    script = ''
      mkdir -p ${webroot}
      cp -r ${piwigo}/* ${webroot}
      mkdir -p ${webroot}/_data
      cp ${./config.inc.php} ${webroot}/include/config.inc.php

      chmod -R 755 ${webroot}/
      chown -R piwigo:piwigo ${webroot}
    '';
  };

  services.nginx = {
    enable = true;
    virtualHosts."photos.astrid.tech" = {
      enableACME = true;
      forceSSL = true;
      root = webroot;

      extraConfig = ''
        index index.php index.htm index.html;
        client_max_body_size 100M;
      '';

      locations."~ .php$".extraConfig = ''
        fastcgi_pass  unix:${config.services.phpfpm.pools.piwigo-pool.socket};
        fastcgi_index index.php;
      '';
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    ensureDatabases = [ "piwigo" ];

    ensureUsers = [
      {
        name = "piwigo";
        ensurePermissions = { "piwigo.*" = "ALL PRIVILEGES"; };
      }
      {
        name = "backup";
        ensurePermissions = { "*.*" = "SELECT, LOCK TABLES"; };
      }
    ];
  };

  services.mysqlBackup.databases = [ "piwigo" ];
  astral.backup.services.paths = [ "${webroot}/_data" ];

  users.groups.piwigo = { };
  users.users."piwigo" = {
    group = "piwigo";
    isSystemUser = true;
  };

  services.phpfpm.pools.piwigo-pool = {
    user = "piwigo";
    phpPackage = pkgs.php74;
    settings = {
      pm = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };
}
