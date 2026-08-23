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
      slack
      slack-term
      zoom-us
    ];

  flatpaks = [
    # it goes out of date very frequently. therefore, install via this
    "org.signal.Signal"
  ];

  nixos = {
    programs.chromium.enable = true;
    nixpkgs.config.allowUnfree = true;
  };
}
