{
  description = "Media Production";

  selector =
    ps: with ps; 
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      kdePackages.kdenlive
      darktable
      gimp
      inkscape
      krita
      lmms
      musescore
      obs-studio
      openutau
      tenacity
    ];
}
