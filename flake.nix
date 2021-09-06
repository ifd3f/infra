{
  description = "astralbijection's infrastructure flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, ... }@inputs:
    let
      installerResult = (import ./nixos/systems/installerISO.nix) inputs;
    in
    {
      nixosConfigurations = {
        bongusHV = (import ./nixos/systems/bongusHV.nix) inputs;
        cracktopHV = (import ./nixos/systems/cracktopHV.nix) inputs;
        bananaPC = (import ./nixos/systems/bananaPC.nix) inputs;
        installerISO = installerResult;
      };

      packages = {
        "x86_64-linux" = {
          # note: unstable needs GC_DONT_GC=1 (https://github.com/NixOS/nix/issues/4246)
          installerISO = installerResult.config.system.build.isoImage;
        };
      };
    };
}
