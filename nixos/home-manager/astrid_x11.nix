# X11-enabled home manager settings
{ pkgs, ... }:
{
  imports = [
    ./astrid.nix
  ];

  fonts.fontconfig.enable = true;

  services = {
    gammastep = {
      enable = true;
      tray = true;
      provider = "geoclue2";
    };
  };

  programs = {
    firefox.enable = true;
    chromium.enable = true;
  };

  # Set up a XFCE/i3 thing
  xsession = {
    windowManager.i3.enable = true;
  };

  home.packages = with pkgs; [
    # Chat apps
    slack
    slack-term
    discord
    discord-canary
    signal-desktop
    element-desktop

    # Office tools
    libreoffice-fresh
    thunderbird
    zoom-us
    evince
    nomacs

    # Development tools
    vscode-fhs
    texstudio
    gitkraken
    jetbrains.idea-ultimate

    # Media editing tools
    xournalpp
    inkscape
    gimp
    krita

    # Security
    bitwarden
    veracrypt
  ];
}
