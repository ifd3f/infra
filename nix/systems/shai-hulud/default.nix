{ self, nixpkgs-unstable, ... }:
self.lib.nixosSystem' {
  nixpkgs = nixpkgs-unstable;
  system = "x86_64-linux";
  modules = [ ./configuration.nix ];
}
