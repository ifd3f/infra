{
  name = "chat";
  description = "Chat and communication tools";
  progFn = { pkgs }: {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      slack
      slack-term
      discord
      discord-canary
      signal-desktop
      element-desktop
      zoom-us
    ];
  };
}
