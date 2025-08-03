{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    anki
    calibre
    libreoffice-fresh
    thunderbird
    xournalpp
  ];
}
