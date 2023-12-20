# Home media server, hooked up directly to the TV.
inputs:
{ config, pkgs, lib, ... }:
let vs = config.vault-secrets.secrets.media-server;
in with lib; {
  services.xserver = {
    enable = true;

    displayManager.autoLogin = {
      enable = true;
      user = "tv";
    };

    displayManager.defaultSession = "gnome";

    desktopManager.kodi.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.firefox.enable = true;
  programs.gnome-terminal.enable = true;

  users = {
    users.tv = {
      group = "tv";
      extraGroups = [ "deluge" ];
      isNormalUser = true;
    };
    users.astrid.extraGroups = [ "tv" ];

    groups.tv = { };
  };

  environment.systemPackages = with pkgs; [ vlc ];
}
