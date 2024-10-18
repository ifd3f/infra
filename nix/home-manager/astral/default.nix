{ pkgs, ... }:
{
  imports = [
    ./cli
    ./macos
    ./vi
    ./gui
  ];
  home = {
    username = "astrid";
    homeDirectory = if pkgs.stdenv.isLinux then "/home/astrid" else "/Users/astrid";
    stateVersion = "22.11";
  };
}
