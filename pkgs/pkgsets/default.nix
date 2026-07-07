/**
  stupid bastard meta-module for defining groups of packages to enable all at once
*/
{
  self,
  config,
  lib,
  ...
}:
with lib;
let
  allPkgSets = config.astral.pkgsets;

  pkgsetSubmodule = {
    options = {
      name = mkOption {
        description = "Human-friendly name for this package set";
        type = types.str;
      };
      selector = mkOption {
        description = "A function that takes in a `pkgs` object, and returns a list of packages to add to the environment";
        type = with types; (functionTo (listOf package));
        default = _: [ ];
      };
      fonts = mkOption {
        description = "A function that takes in a `pkgs` object, and returns a list of font packages";
        type = with types; (functionTo (listOf package));
        default = _: [ ];
      };
      nixos = mkOption {
        description = ''
          NixOS configs to add in addition to existing package selectors.

          This MUST be `mkMerge`able -- in other words, no `imports` or `options`, only
          `config` values.
        '';
        type = types.anything;
        default = { };
      };
    };
  };
in
{
  _class = "flake";

  options.astral.pkgsets = mkOption {
    description = "Package sets";
    type = with types; attrsOf (submodule pkgsetSubmodule);
  };

  config = {
    astral.pkgsets = {
      basics = ./basics.nix;
      fonts = ./fonts.nix;
      security = ./security.nix;
      utils = ./utils.nix;

      graphics-basics = ./graphics/basics.nix;
      graphics-cad = ./graphics/cad.nix;
      graphics-dev = ./graphics/dev.nix;
      graphics-drone = ./graphics/drone.nix;
      graphics-games = ./graphics/games.nix;
      graphics-internet = ./graphics/internet.nix;
      graphics-media-production = ./graphics/media-production.nix;
      graphics-office = ./graphics/office.nix;
      graphics-radio = ./graphics/radio.nix;
    };

    debug = true;

    perSystem = { pkgs, ... }: {
      packages =
        let
          envs = mapAttrs' (
            pkgsetKeyname: pkgsetConfig:
            let
              name = "pkgsetenv-${pkgsetKeyname}";
              normalPkgList = pkgsetConfig.selector pkgs;

              # NOTE: This operation can cause fonts to get overriden with ones defined earlier
              # or later. Oh well!
              filteredFonts = pkgs.symlinkJoin {
                name = "filtered-fonts";
                paths = map (
                  # This operation removes fonts.dir.
                  #
                  # While a slightly "nicer" way to go about it would be to cat | sort | uniq
                  # them together, I'm getting rid of X11 across all my machines anyways so it's
                  # not worth the hassle.
                  p:
                  pkgs.runCommand "${p.name}" { } ''
                    cp -r ${p} $out
                    chmod -R 700 $out
                    rm -f $out/share/fonts/misc/fonts.dir
                  ''
                ) (pkgsetConfig.fonts pkgs);
              };
            in
            {
              inherit name;
              value = pkgs.buildEnv {
                inherit name;
                paths = normalPkgList ++ [ filteredFonts ];
                passthru.pkgset = pkgsetConfig;
              };
            }
          ) allPkgSets;
        in
        envs;
    };

    flake.nixosModules.pkgsets = { config, pkgs, ... }: {
      _class = "nixos";

      options.astral.pkgsets = mapAttrs (_: pkgsetConfig: {
        enable = mkEnableOption "${pkgsetConfig.name} package set";
      }) allPkgSets;

      config = mkMerge (
        mapAttrsToList (
          pkgsetKeyname: pkgsetConfig:
          mkIf config.astral.pkgsets.${pkgsetKeyname}.enable (mkMerge [
            pkgsetConfig.nixos
            {
              environment.systemPackages = pkgsetConfig.selector pkgs;
              fonts.packages = pkgsetConfig.fonts pkgs;
            }
          ])
        ) allPkgSets
      );
    };
  };
}
