{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bitwarden
    cheese
    flameshot
    nomacs
    obs-studio
    remmina
    tenacity-unstable
    vlc
    xclip
    xev
  ];
}
