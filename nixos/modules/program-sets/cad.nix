{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # kicad-small # broken for now
    openscad
    # freecad # broken for now
  ];
}
