{ self, ... }:
{
  _class = "flake";

  perSystem =
    { self', pkgs, ... }:
    {
      packages = {
        rescue = pkgs.callPackage ./rescue { baseModule = self.nixosModules.astral; };
      };
    };
}
