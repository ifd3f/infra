{ pkgs, lib, config, ... }:
let cfg = config.astral.custom-nginx-errors;
in with lib; {
  options.astral.custom-nginx-errors.enable =
    mkEnableOption "Customized nginx errors";

  config = mkIf cfg.enable {
    services.nginx = {
    };
  };
}
