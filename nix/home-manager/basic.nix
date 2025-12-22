{ config, pkgs, ... }:

{
  home.username = "astrid";
  home.homeDirectory = "/home/astrid";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    starship
  ];
}

