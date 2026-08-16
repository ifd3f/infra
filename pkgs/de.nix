# An env you can `nix profile add` to populate a user shell with my customized desktop environment
{
  buildEnv,
  astral,
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
    fuzzel
    way-displays
    waybar
    wlrctl
  ];
}
