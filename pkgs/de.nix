# An env you can `nix profile add` to populate a user shell with my customized desktop environment
{
  buildEnv,
  astral,
}:
let
  name = "astrid-de";
in
buildEnv {
  inherit name;
  ignoreCollisions = true;
  paths = [
    astral.myorilla
  ];
}
