{
  name = "office";
  description = "Office tools";
  progFn = { pkgs }: {
    environment.systemPackages = with pkgs; [
      gimp
      inkscape
      krita
      libreoffice-fresh
      lmms
      okular
      polymc
      thunderbird
      xournalpp
    ];
  };
}
