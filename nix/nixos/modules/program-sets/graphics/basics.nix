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
    vlc
    wdisplays
    webcamoid
    xclip
  ];
}
