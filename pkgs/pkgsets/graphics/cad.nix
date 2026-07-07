{
  name = "Cad";

  selector =
    ps: with ps; [
      #kicad
      # bambu-studio causing ooms while compiling???
      openscad-unstable
      freecad
    ];
}
