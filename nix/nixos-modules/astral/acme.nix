{ config, lib, ... }:
with lib; {
  options.astral.acme.enable = mkOption {
    description = "Enable to set up pre-customized ACME stuff.";
    default = false;
    type = types.bool;
  };

  config = mkIf config.astral.acme.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "astrid@astrid.tech";
    };
  };
}
