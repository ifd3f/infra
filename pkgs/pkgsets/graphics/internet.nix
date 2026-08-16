{
  description = "Internet";

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
      signal-desktop
      slack
      slack-term
      zoom-us
    ];

  nixos = {
    programs.chromium.enable = true;
    nixpkgs.config.allowUnfree = true;
  };
}
