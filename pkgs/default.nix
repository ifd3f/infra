{ self, ... }:
{
  _class = "flake";

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        rescue = pkgs.callPackage ./rescue { baseModule = self.nixosModules.astral; };
      };
    };
}
