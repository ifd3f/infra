# An env you can `nix profile add` to populate a user shell with nice tools
{
  buildEnv,
  linkFarm,

  astral,
  vimPlugins,
  callPackage,
}:
let
  name = "astrid-home";
in
buildEnv {
  inherit name;
  ignoreCollisions = true;
  paths = [
    (
      with vimPlugins;
      linkFarm "${name}-nvim" {
        # "share/nvim/site/plugin/lazy-nvim" = lazy-nvim;
      }
    )

    astral.pkgsets.basics
    astral.pkgsets.cli-env
    astral.pkgsets.dev
    astral.pkgsets.utils
  ];
}
