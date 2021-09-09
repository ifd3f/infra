# Updates the system from this flake every day.

{ pkgs, ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "github:astralbijection/infra/main";
    dates = "*-*-* 4:00:00";
    randomizedDelaySec = "30min";
  };
}
