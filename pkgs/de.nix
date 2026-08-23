# An env you can `nix profile add` to populate a user shell with my customized desktop environment
{
  astral,
  nur,

  buildEnv,
  dunst,
  fuzzel,
  way-displays,
  waybar,
  wlrctl,
}:
let
  name = "astrid-de";
in
buildEnv {
  inherit name;
  ignoreCollisions = true;
  paths = [
    astral.myorilla
    nur.repos.ifd3f.argen
    dunst
    fuzzel
    way-displays
    waybar
    wlrctl
  ];
}
