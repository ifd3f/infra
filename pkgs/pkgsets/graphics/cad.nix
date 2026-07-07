{
  description = "Cad";

  selector =
    ps:
    with ps;
    lib.optionals ps.stdenv.hostPlatform.isLinux [

      #kicad
      # bambu-studio causing ooms while compiling???
      openscad-unstable
      freecad
    ];
}
