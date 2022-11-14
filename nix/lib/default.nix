{ self, defaultNixpkgs, inputs, system ? null }: rec {
  sshKeyDatabase = import ../../ssh_keys;

  nixosSystem' = { system, modules, nixpkgs ? defaultNixpkgs }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.armqr.nixosModules.default
        "${inputs.nixpkgs-akkoma}/nixos/modules/services/web-apps/akkoma.nix"
        self.nixosModule
      ] ++ modules;

      specialArgs = { inherit inputs; };
    };
}
