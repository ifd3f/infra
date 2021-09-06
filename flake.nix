{
  description = "astralbijection's infrastructure flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }: {

    nixosConfigurations = {
      bongus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [ (import ./nixos/hardware-configuration/bongus.nix)
            (import ./nixos/systems/bongus.nix)
          ];
      };
    };

  };
}