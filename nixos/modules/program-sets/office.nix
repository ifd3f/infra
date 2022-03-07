{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gimp
    inkscape
    krita
    libreoffice-fresh
    lmms
    okular
    thunderbird
    xournalpp
  ];
}
