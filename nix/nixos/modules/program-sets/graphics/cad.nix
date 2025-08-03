{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #kicad
    bambu-studio
    openscad-unstable
    freecad
  ];
}
