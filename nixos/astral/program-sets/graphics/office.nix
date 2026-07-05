{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.graphics.office;
in
{
  options.astral.program-sets.graphics.office = {
    enable = lib.mkEnableOption "astral.program-sets.graphics.office";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      anki
      calibre
      libreoffice-fresh
      thunderbird
      xournalpp
    ];
  };
}
