{
  perSystem =
    { self', pkgs, ... }:
    {
      devShells = rec {
        infra = pkgs.mkShell {
          VAULT_ADDR = "https://secrets.astrid.tech";
          propagatedBuildInputs = [
            # TODO: self'.packages.pkgsetenv-basics
            self'.packages.pkgsetenv-infradev
            self'.packages.pkgsetenv-security
            # TODO: self'.packages.pkgsetenv-utils
          ];
        };

        default = infra;
      };
    };
}
