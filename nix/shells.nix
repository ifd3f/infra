{
  perSystem =
    { self', pkgs, ... }:
    {
      devShells = rec {
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

        default = infra;
      };
    };
}
