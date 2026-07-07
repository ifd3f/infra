{
  description = "Cad";

  selector =
    ps:
    with ps;
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      kicad
      openscad-unstable
      freecad
    ];
}
