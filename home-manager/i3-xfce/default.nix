# X11-enabled home manager settings
{ pkgs, lib, ... }:
let
  mod = "Mod4";

  workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "y" "u" "i" "o" "p"];
  workspaceBinds =
    (lib.imap1 
      (i: k: let si = toString i; in {
        "${mod}+${k}" = "workspace number ${si}";
        "${mod}+Shift+${k}" = "move container to workspace number ${si}";
      })
      workspaces);

  # Usage: forEachDirKey (d: k: { "${mod}+${k}" = "focus ${d}"; });
  forEachDirKey = f: 
    (map (f "left")  ["h" "Left"]) ++
    (map (f "down")  ["j" "Down"]) ++
    (map (f "up")    ["k" "Up"])   ++
    (map (f "right") ["l" "Right"]);

  focusDirBinds = forEachDirKey (d: k: { "${mod}+${k}" = "focus ${d}"; });
  moveDirBinds = forEachDirKey (d: k: { "${mod}+Shift+${k}" = "move ${d}"; });
in
{
  # Set up a XFCE/i3 thing
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      keybindings = (lib.mkMerge (workspaceBinds ++ focusDirBinds ++ moveDirBinds)) // {
        "${mod}+Return" = "exec i3-sensible-terminal";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec dmenu_run";

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
