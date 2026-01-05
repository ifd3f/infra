{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.graphics.cad;
in
{
  options.astral.program-sets.graphics.cad = {
    enable = lib.mkEnableOption "astral.program-sets.graphics.cad";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      #kicad
      bambu-studio
      openscad-unstable
      freecad
    ];
  };
}
