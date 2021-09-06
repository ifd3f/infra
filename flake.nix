{
  description = "astralbijection's infrastructure flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }:
    let
      moduleArgs = { self = self; nixpkgs = nixpkgs; };
    in
    {

      nixosConfigurations = {
        bongusHV = (import ./nixos/systems/bongus.nix) moduleArgs;
      };

    };
}
