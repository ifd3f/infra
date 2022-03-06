{ pkgs, ... }:
{
  programs = {
    chromium.enable = true;
  };

  environment.systemPackages = with pkgs; [
    firefox
  ];
}