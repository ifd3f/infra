{ pkgs, ... }:
{
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
}
