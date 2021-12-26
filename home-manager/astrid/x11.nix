# X11-enabled home manager settings
{ self, ... }:
{ pkgs, ... }:
let
  commonAliases = {
    # Pipe to/from clipboard
    "c" = "xclip -selection clipboard";
    "v" = "xclip -o -selection clipboard";
  };
in {
  imports = with self.homeModules; [ astrid_alacritty ];

  nixpkgs.config.allowUnfree = true;

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

    zsh.shellAliases = commonAliases;
    bash.shellAliases = commonAliases;
  };

  # home.file.".face" = {
  #   source = ./astrid.png;
  # };

  home.packages = with pkgs;
    [
      # GUI to CLI adapter
      xclip
    ];
}
