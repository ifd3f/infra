{ self, ... }:
{
  _class = "flake";

  perSystem =
    { self', pkgs, ... }:
    {
      packages = {
        inherit (pkgs.astral)
          astrid-de
          astrid-home
          myorilla
          nvim-pack
          ;

        rescue = pkgs.callPackage ./rescue { baseModule = self.nixosModules.astral; };
      };
    };
}
