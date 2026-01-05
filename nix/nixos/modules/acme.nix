{ config, lib, ... }:
let
  cfg = config.astral.acme;
in
{
  options.astral.acme.enable = lib.mkEnableOption "astral.acme";

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "astrid@astrid.tech";
    };
  };
}
