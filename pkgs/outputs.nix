{ self, ... }:
{
  _class = "flake";

  perSystem =
    { self', pkgs, ... }:
    {
      packages = {
        inherit (pkgs.astral) nvim-pack;

        astrid-home = pkgs.callPackage ./home.nix { };
        rescue = pkgs.callPackage ./rescue { baseModule = self.nixosModules.astral; };
      };
    };
}
