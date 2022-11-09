{ self, lib, nixpkgs-akkoma, nixos-hardware, armqr, system ? null }: rec {
  sshKeyDatabase = import ../../ssh_keys;

  nixosSystem = { system, modules }:
    lib.nixosSystem {
      inherit system;
      modules = [
        armqr.nixosModules.default
        "${nixpkgs-akkoma}/nixos/modules/services/web-apps/akkoma.nix"
        self.nixosModule
      ] ++ modules;

      specialArgs = { inherit nixos-hardware; };
    };
}
