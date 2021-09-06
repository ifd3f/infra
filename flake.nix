{
  description = "astralbijection's infrastructure flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  };

  outputs = { self, nixpkgs }:
    let
      inputs = { self = self; nixpkgs = nixpkgs; };
    in
    {
      nixosConfigurations = {
        bongusHV = (import ./nixos/systems/bongus.nix) inputs;
        cracktopHV = (import ./nixos/systems/cracktop.nix) inputs;
        bananaPC = (import ./nixos/systems/banana.nix) inputs;
      };
    };
}
