# Set up a XFCE/i3 thing
{ pkgs, ... }:
{
  services.xserver = {
    enable = true;

    displayManager = {
      startx.enable = true;
      defaultSession = "xfce+i3";
    };

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    windowManager.i3.enable = true;
  };
}
