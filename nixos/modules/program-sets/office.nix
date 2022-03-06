{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gimp
    inkscape
    krita
    libreoffice-fresh
    okular
    thunderbird
    xournalpp
  ];
}
