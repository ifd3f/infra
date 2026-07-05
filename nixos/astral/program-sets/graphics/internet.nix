{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.graphics.internet;
in
{
  options.astral.program-sets.graphics.internet = {
    enable = lib.mkEnableOption "astral.program-sets.graphics.internet";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium.enable = true;

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
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
  };
}
