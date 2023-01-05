{ config, pkgs, lib, ... }: {
  services.armqr = {
    enable = true;
    port = 63423;
  };

  services.nginx = {
    enable = true;
    virtualHosts = let
      conf = {
        enableACME = true;
        addSSL = true;
        forceSSL = false;
        locations."/".proxyPass =
          "http://127.0.0.1:${toString config.services.armqr.port}";
      };
    in {
      "qr.arm.astridyu.com" = conf;
      "0q4.org" = conf;
    };
  };
}
