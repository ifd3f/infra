{
  name = "x11";
  description = "Basic tools for working in X11 environments";
  progFn = { pkgs }: {
    environment.systemPackages = with pkgs; [
      bitwarden
      brightnessctl
      flameshot
      nomacs
      obs-studio
      remmina
      tenacity
      vlc
      xclip
      xorg.xev
    ];
  };
}
