{
  name = "Internet";

  selector =
    ps: with ps; [
      firefox
      discord
      discord-canary
      element-desktop
      gajim
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
