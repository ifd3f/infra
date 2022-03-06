{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    slack
    slack-term
    discord
    discord-canary
    signal-desktop
    element-desktop
    zoom-us
  ];
}
