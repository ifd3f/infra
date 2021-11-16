{ pkgs, ... }:
{
  home.packages = with pkgs; [
    meslo-lgs-nf
  ];

  programs.alacritty = {
    enable = true;
    settings = { 
      font = {
        size = 9;
        normal.family = "MesloLGS NF";
      };
    };
  };
}
