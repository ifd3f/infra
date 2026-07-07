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
    (linkFarm "${name}-nvim" {
      "share/nvim/site/pack/astrid_home_provided" = callPackage ./nvim/mkPack.nix {
        name = "astrid-nvim-pack";

        startPlugins = with vimPlugins; {
          # TODO: as this system becomes better-developed, possibly get
          # rid of lazy-nvim?
          "lazy.vim" = lazy-nvim;
        };
        optPlugins = {
          # TODO
        };
      };
    })

    astral.pkgsets.basics
    astral.pkgsets.cli-env
    astral.pkgsets.dev
    astral.pkgsets.utils
  ];
}
