{
  name = "office";
  description = "Office tools";
  progFn = { pkgs }: {
    environment.systemPackages = with pkgs; [
      darktable
      gimp
      inkscape
      kdenlive
      krita
      libreoffice-fresh
      lmms
      musescore
      okular
      prismlauncher
      thunderbird
      xournalpp
    ];
  };
}
