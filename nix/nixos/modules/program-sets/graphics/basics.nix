{ pkgs, ... }:
{
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
    transmission_3
    transmission_3-qt
    vlc
    wdisplays
    webcamoid
    xclip
  ];
}
