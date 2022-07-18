{
  name = "cad";
  description = "Computer-aided design";
  progFn = { pkgs }: {
    environment.systemPackages = with pkgs;
      [
        kicad
        openscad
        freecad
      ];
  };
}
