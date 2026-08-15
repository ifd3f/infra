{
  perSystem =
    { self', pkgs, ... }:
    {
      devShells = {
        full =
          with pkgs;
          mkShell {
            inputsFrom = [
              self'.devShells.rust
              self'.devShells.infra
            ];
          };

        default = self'.devShells.full;

        infra =
          with pkgs;
          mkShell {
            VAULT_ADDR = "https://secrets.astrid.tech";
            propagatedBuildInputs = [
              astral.pkgsets.basics
              astral.pkgsets.infradev
              astral.pkgsets.security
              astral.pkgsets.utils
            ];
          };

        # this is used for orilla configuration
        rust =
          with pkgs;
          mkShell {
            RUST_SRC_PATH = rustPlatform.rustLibSrc;
            buildInputs = [
              cargo
              rustc
              rustfmt
              pre-commit
              rustPackages.clippy
            ];
          };
      };
    };
}
