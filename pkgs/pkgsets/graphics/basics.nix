{
  name = "Basics";

  selector =
    ps:
    with ps;
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      kdePackages.ark
      kdePackages.okular
      kdePackages.dolphin

      alacritty
      brightnessctl
      flameshot
      nomacs
      pavucontrol
      remmina
      tenacity
      transmission_4-qt
      vlc
      wdisplays
      webcamoid
      xclip
      xev
    ];
}
