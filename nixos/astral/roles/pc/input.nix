{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.astral.roles.pc.enable {
    services.libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        libsForQt5.fcitx5-qt
      ];
    };
  }

  ;
}
