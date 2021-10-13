# XClip + pipe to c and v alias
{ pkgs, ... }: let
  commonAliases = {
    # Pipe to/from clipboard
    "c" = "xclip -selection clipboard";
    "v" = "xclip -o -selection clipboard";
  };
in {
  home.packages = [ pkgs.xclip ];

  zsh.shellAliases = commonAliases;
  bash.shellAliases = commonAliases;
}
