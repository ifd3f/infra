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
    transmission_4
    transmission_4-qt
    vlc
    wdisplays
    webcamoid
    xclip
  ];
}
