{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.graphics.radio;
in
{
  options.astral.program-sets.graphics.radio = {
    enable = lib.mkEnableOption "astral.program-sets.graphics.radio";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      chirp
      dmrconfig
      gnuradio
      gnuradio
      hackrf
      qdmr
      sdrpp
      soapysdr-with-plugins
      wsjtx
      wsjtz
    ];
  };
}
