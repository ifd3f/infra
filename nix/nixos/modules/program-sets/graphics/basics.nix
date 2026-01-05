{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.graphics.basics;
in
{
  options.astral.program-sets.graphics.basics = {
    enable = lib.mkEnableOption "astral.program-sets.graphics.basics";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.ark
      kdePackages.okular
      kdePackages.dolphin

      xorg.xev

      alacritty
      brightnessctl
      flameshot
      nomacs
      pavucontrol
      remmina
      tenacity
      transmission_4
      transmission_4-qt
      vlc
      wdisplays
      webcamoid
      xclip
    ];
  };
}
