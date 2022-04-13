{
  name = "browsers";
  description = "Internet browsers";
  progFn =  { pkgs }: {
    programs.chromium.enable = true;
    environment.systemPackages = with pkgs; [ firefox ];
    xdg.portal.gtkUsePortal = true; # for firefox to hopefully not break
  };
}
