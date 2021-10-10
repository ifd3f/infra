# X11-enabled home manager settings
{ pkgs, ... }: {
  imports = [ ./astrid.nix ];

  nixpkgs.config.allowUnfree = true;
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

    neovim = {
      plugins = with pkgs.vimPlugins; [
        vimtex
      ];
    };
  };

  # home.file.".face" = {
  #   source = ./astrid.png;
  # };

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
    okular
    nomacs

    # Development tools
    vscode-fhs
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

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = [ "org.kde.okular.desktop" ];
    };
  };
}
