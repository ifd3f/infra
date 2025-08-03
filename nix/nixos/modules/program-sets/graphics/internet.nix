{ pkgs, ... }:
{
  programs.chromium.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    firefox
    discord
    discord-canary
    element-desktop
    gajim
    signal-desktop
    slack
    slack-term
    zoom-us
  ];
}
