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

    (openttd-jgrpp.overrideAttrs (oldAttrs: {
      src = fetchFromGitHub {
        owner = "JGRennison";
        repo = "OpenTTD-patches";
        rev = "jgrpp-0.69.2";
        sha256 = "sha256-D9Oh05Isf7Atsih6tZBA8xS04aCuE8VS5Ghf0FvrU5A=";
      };
      version = "0.69.2";
    }))
  ];
}
