{ config, pkgs, ... }:
let
  piwigo = pkgs.fetchFromGitHub {
    owner = "Piwigo";
    repo = "Piwigo";
    rev = "13.1.0";
    hash = "sha256-T3R5zfuDl1y3iNUrbouZlljDaNdtBTNro46fr+V67Oo=";
  };
in {
  services.nginx = {
    enable = true;
    virtualHosts."photos.astrid.tech" = {
      enableACME = true;
      forceSSL = true;
      root = piwigo;
      locations."~ .php$".extraConfig = ''
        fastcgi_pass  unix:${config.services.phpfpm.pools.piwigo-pool.socket};
        fastcgi_index index.php;
      '';
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    ensureDatabases = [ "photos" ];

    ensureUsers = [
      {
        name = "photos";
        ensurePermissions = { "piwigo.*" = "ALL PRIVILEGES"; };
      }
      {
        name = "backup";
        ensurePermissions = { "*.*" = "SELECT, LOCK TABLES"; };
      }
    ];
  };

  services.phpfpm.pools.piwigo-pool = {
    user = "nobody";
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
