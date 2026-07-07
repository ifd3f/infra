{
  name = "Office";

  selector =
    ps: with ps; 
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      anki
      calibre
      libreoffice-fresh
      thunderbird
      xournalpp
    ];
}
