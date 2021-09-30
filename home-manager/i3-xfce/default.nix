# X11-enabled home manager settings
{ pkgs, ... }:
{
  # Set up a XFCE/i3 thing
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    extraConfig = builtins.readFile ./i3.conf;
  };

  programs.rofi = {
    enable = true;
    theme = "glue-pro-blue";
    lines = 30;

    extraConfig = {
      modi = "window,drun,run,ssh";
      levenshtein-sort = true;
      sidebar-mode = true;
    };
  };
}
