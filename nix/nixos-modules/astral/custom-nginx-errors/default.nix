{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.astral.custom-nginx-errors;
in
with lib;
{
  options.astral.custom-nginx-errors.virtualHosts = mkOption {
    description = "List of hosts to add customized errors to.";
    type = with types; listOf str;
    default = [ ];
  };

  config.services.nginx.virtualHosts = listToAttrs (
    map (host: {
      name = host;
      value = {
        extraConfig = ''
          error_page 502 /502.html;
        '';

        locations."= /502.html" = {
          root = ./static;
          extraConfig = ''
            internal;
          '';
        };
      };
    }) cfg.virtualHosts
  );
}
