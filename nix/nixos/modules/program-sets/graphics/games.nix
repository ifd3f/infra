{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lutris
    prismlauncher
  ];
}
