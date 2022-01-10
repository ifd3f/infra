# X11-enabled home manager settings
{ self, ... }:
{ pkgs, ... }:
{
  imports = with self.homeModules; [ astrid_alacritty ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    firefox.enable = true;
    chromium.enable = true;
  };

  # home.file.".face" = {
  #   source = ./astrid.png;
  # };

  home.packages = with pkgs;
    [
      # GUI to CLI adapter
      xclip
    ];

  home.shellAliases = {
    # Pipe to/from clipboard
    "c" = "xclip -selection clipboard";
    "v" = "xclip -o -selection clipboard";
  };
}
