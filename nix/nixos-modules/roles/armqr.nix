{ config, pkgs, lib, ... }:
let inputs = config.astral.inputs;
port = 63423;
in {
  imports = [ inputs.armqr.nixosModules.default ];

  services.armqr = {
    enable = true;
    inherit port;
  };

  services.nginx = {
    enable = true;
    virtualHosts = let
      conf = {
        enableACME = true;
        addSSL = true;
        forceSSL = false;
        locations."/".proxyPass =
          "http://127.0.0.1:${toString port}";
      };
    in {
      "qr.arm.astridyu.com" = conf;
      "0q4.org" = conf;
    };
  };
}
