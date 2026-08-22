{
  description = "Internet";

  # NOTES:
  # - signal-desktop keeps going out of date so we omit it. use flatpak org.signal.Signal instead
  selector =
    ps:
    with ps;
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      firefox
      discord
      discord-canary
      element-desktop
      gajim # xmpp
      hexchat # irc
      slack
      slack-term
      zoom-us
    ];

  nixos = {
    programs.chromium.enable = true;
    nixpkgs.config.allowUnfree = true;
  };
}
