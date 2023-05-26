{ self, nixpkgs-stable, ... }:
self.lib.nixosSystem' {
  nixpkgs = nixpkgs-stable;
  system = "x86_64-linux";
  modules = [ ./configuration.nix ];
}
