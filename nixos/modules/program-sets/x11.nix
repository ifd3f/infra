{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bitwarden
    gnome.cheese
    flameshot
    nomacs
    obs-studio
    remmina
    tenacity
    vlc
    xclip
    xorg.xev
  ];
}
