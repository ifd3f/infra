{ powerlevel10k }:
{ pkgs, ... }: {
  imports = [ (import ./cli { inherit powerlevel10k; }) ./macos ./vi ./gui ];
  home = {
    username = "astrid";
    homeDirectory =
      if pkgs.stdenv.isLinux then "/home/astrid" else "/Users/astrid";
    stateVersion = "22.11";
  };
}
