{ pkgs, ... }:
{
  home.packages = with pkgs; [
    meslo-lgs-nf
  ];

  programs.alacritty = {
    enable = false;
    settings = { 
      font = {
        size = 9;
        normal.family = "MesloLGS NF";
      };
    };
  };
}
