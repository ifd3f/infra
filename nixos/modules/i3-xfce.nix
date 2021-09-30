# Set up a XFCE/i3 thing
{ pkgs, ... }:
{
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce";
    };

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = false;
        enableXfwm = false;
      };
    };

    windowManager.i3.enable = false;
  };
}
