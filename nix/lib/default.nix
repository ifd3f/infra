{ self, nixpkgs, nixpkgs-akkoma, nixos-hardware, armqr
, system ? null }: rec {
  sshKeyDatabase = import ../../ssh_keys;

  nixosSystem' = { system, modules, nixpkgs ? nixpkgs }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        armqr.nixosModules.default
        "${nixpkgs-akkoma}/nixos/modules/services/web-apps/akkoma.nix"
        self.nixosModule
      ] ++ modules;

      specialArgs = { inherit nixos-hardware; };
    };
}
