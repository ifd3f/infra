{ config, pkgs, ... }:
{
  imports = [
    "./sshd.nix"
  ];

  time.timeZone = "US/Pacific";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    neovim
    curl
  ];
}