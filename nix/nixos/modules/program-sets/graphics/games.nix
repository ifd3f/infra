{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    # localNetworkGameTransfers.openFirewall = true;
  };

  # programs.gamescope.enable = true;

  # nixpkgs.config.packageOverrides = pkgs: {
  #   steam = pkgs.steam.override {
  #     extraPkgs = pkgs: with pkgs; [
  #       gamescope
  #     ];
  #   };
  # };

  environment.systemPackages = with pkgs; [
    gamescope
    lutris
    prismlauncher
  ];
}
