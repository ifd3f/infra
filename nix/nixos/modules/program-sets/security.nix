{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.security;
in
{
  options.astral.program-sets.security = {
    enable = lib.mkEnableOption "astral.program-sets.security";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tpm2-tools
      tpm2-tss
    ];
  };
}
