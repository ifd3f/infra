# X11-enabled home manager settings
{ pkgs, lib, ... }:
let
  mod = "Mod4";

  workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "y" "u" "i" "o" "p"];
  workspaceBinds = lib.mkMerge 
    (lib.imap1 
      (i: k: let si = toString i; in {
        "${mod}+${k}" = "workspace number ${si}";
        "${mod}+Shift+${k}" = "move container to workspace number ${si}";
      })
      workspaces);

  keySets = {
    left = ["h" "Left"];
    right = ["j" "Right"];
    up = ["k" "UP"];
    down = ["l" "Down"];
  };
in
{
  # Set up a XFCE/i3 thing
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      keybindings = workspaceBinds // {
        "${mod}+Return" = "exec i3-sensible-terminal";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec dmenu_run";

        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+Shift+%" = "split h";
        "${mod}+Shift+'" = "split v";
        "${mod}+f" = "fullscreen toggle";

        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        "${mod}+a" = "focus parent";

        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";
      };
    };
    #extraConfig = builtins.readFile ./i3.conf;
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
