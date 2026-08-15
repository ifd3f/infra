{ self, ... }:
{
  _class = "flake";

  perSystem =
    { self', pkgs, ... }:
    {
      packages = {
        inherit (pkgs.astral) myorilla nvim-pack;

        astrid-home = pkgs.callPackage ./home.nix { };
        astrid-de = pkgs.callPackage ./de.nix { };
        rescue = pkgs.callPackage ./rescue { baseModule = self.nixosModules.astral; };
      };
    };
}
