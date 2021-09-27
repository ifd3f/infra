# X11-enabled home manager settings
{ pkgs, ... }:
{
  imports = [
    ./astrid.nix
  ];

  # Set up a XFCE/i3 thing
  xsession = {
    windowManager.i3.enable = true;
  };
}
