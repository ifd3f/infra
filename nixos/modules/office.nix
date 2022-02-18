# A role containing standard office tools :)
{ self, ... }:
{ pkgs, ... }:
{
  # Web browser
  programs = {
    chromium.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Browser
    firefox
    firefox-devedition-bin

    # CAD
    kicad-small
    openscad
    # freecad # broken for now

    # Communication apps
    slack
    slack-term
    discord
    discord-canary
    signal-desktop
    element-desktop
    zoom-us

    # Office
    libreoffice-fresh
    thunderbird
    okular
    nomacs

    # Development
    vscode-fhs
    gitkraken
    jetbrains.idea-ultimate

    # Media editing
    xournalpp
    inkscape
    gimp
    krita

    # Security
    bitwarden
    veracrypt

    # GUI to CLI adapter
    xclip
  ];
}
