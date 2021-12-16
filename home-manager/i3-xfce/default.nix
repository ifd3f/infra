# X11-enabled home manager settings
{ pkgs, lib, ... }:
let
  mod = "Mod4";

  terminal = "alacritty";
  workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "y" "u" "i" "o" "p" ];

  forEachL = lib.forEach [ "h" "Left" ];
  forEachD = lib.forEach [ "j" "Down" ];
  forEachU = lib.forEach [ "k" "Up" ];
  forEachR = lib.forEach [ "l" "Right" ];

  # Usage: forEachDirKey (d: k: { "${mod}+${k}" = "focus ${d}"; });
  forEachDirKey = f:
    (forEachL (f "left")) ++ (forEachD (f "down")) ++ (forEachU (f "up"))
    ++ (forEachR (f "right"));

in {
  # Set up a XFCE/i3 thing
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      keybindings = (lib.mkMerge (let
        focusDirBinds = forEachDirKey (d: k: { "${mod}+${k}" = "focus ${d}"; });
        moveDirBinds =
          forEachDirKey (d: k: { "${mod}+Shift+${k}" = "move ${d}"; });
        workspaceBinds = (lib.imap1 (i: k:
          let si = toString i;
          in {
            "${mod}+${k}" = "workspace number ${si}";
            "${mod}+Shift+${k}" = "move container to workspace number ${si}";
          }) workspaces);
        miscBinds = [{
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+q" = "kill";
          "${mod}+d" = "exec dmenu_run";

          "${mod}+Shift+b" = "split h";
          "${mod}+Shift+v" = "split v";
          "${mod}+f" = "fullscreen toggle";

          "${mod}+x" = "layout stacking";
          "${mod}+z" = "layout tabbed";
          "${mod}+c" = "layout toggle split";

          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";

          "${mod}+a" = "focus parent";

          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";

          "${mod}+r" = "mode resize";

          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+e" = ''
            exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"
          '';
        }];
      in workspaceBinds ++ focusDirBinds ++ moveDirBinds ++ miscBinds));

      modes.resize = let
        resizeBinds =
          (forEachL (k: { "${k}" = "resize shrink width 10 px or 10 ppt"; }))
          ++ (forEachD (k: { "${k}" = "resize grow height 10 px or 10 ppt"; }))
          ++ (forEachU
            (k: { "${k}" = "resize shrink height 10 px or 10 ppt"; }))
          ++ (forEachR (k: { "${k}" = "resize grow width 10 px or 10 ppt"; }));
      in (lib.mkMerge (resizeBinds ++ [{
        "Return" = "mode default";
        "Escape" = "mode default";
      }]));
    };
    extraConfig = builtins.readFile ./kde-include.conf;
  };

  programs.rofi = {
    enable = true;
    theme = "glue-pro-blue";

    extraConfig = {
      modi = "window,drun,run,ssh";
      levenshtein-sort = true;
      sidebar-mode = true;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = { font = { size = 9; }; };
  };
}
