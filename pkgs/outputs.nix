{ self, ... }:
{
  _class = "flake";

  perSystem =
    { self', pkgs, ... }:
    {
      packages = {
        inherit (pkgs.astral) nvim-pack;

        rescue = pkgs.callPackage ./rescue { baseModule = self.nixosModules.astral; };
      };
    };
}
