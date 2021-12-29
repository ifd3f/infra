# Updates the system from this flake every hour.

{ pkgs, ... }: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:astralbijection/infra/main";
    dates = "*-*-* *:00:00";
  };
}
