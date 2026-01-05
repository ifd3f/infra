{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.graphics.drone;
in
{
  options.astral.program-sets.graphics.drone = {
    enable = lib.mkEnableOption "astral.program-sets.graphics.drone";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      edgetx
    ];
  };
}
