{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.graphics.media-production;
in
{
  options.astral.program-sets.graphics.media-production = {
    enable = lib.mkEnableOption "astral.program-sets.graphics.media-production";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.kdenlive

      darktable
      gimp
      inkscape
      krita
      lmms
      musescore
      obs-studio
      openutau
      tenacity
    ];
  };
}
