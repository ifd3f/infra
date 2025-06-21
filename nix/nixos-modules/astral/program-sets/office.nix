{
  name = "office";
  description = "Office tools";
  progFn = { pkgs }: {
    environment.systemPackages = with pkgs; [
      darktable
      gimp
      inkscape
      kdePackages.kdenlive
      krita
      libreoffice-fresh
      lmms
      musescore
      kdePackages.okular
      prismlauncher
      thunderbird
      xournalpp
    ];
  };
}
