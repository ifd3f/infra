{ self, nixpkgs-stable, ... }:
self.lib.nixosSystem' {
  nixpkgs = nixpkgs-stable;
  system = "aarch64-linux";
  modules = [ ./configuration.nix ];
}
