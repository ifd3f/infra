{
  name = "office";
  description = "Office tools";
  progFn = { pkgs }: {
    environment.systemPackages = with pkgs; [
      gimp
      darktable
      inkscape
      krita
      libreoffice-fresh
      lmms
      okular
      polymc
      kdenlive
      thunderbird
      xournalpp
    ];
  };
}
