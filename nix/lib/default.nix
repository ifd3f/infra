{ self, defaultNixpkgs, inputs, system ? null }:
let inherit (inputs.nixpkgs-unstable) lib;
in rec {
  sshKeyDatabase = import ../../ssh_keys;

  ciGraph = import ../ci.nix { inherit self lib; };

  nixosSystem' = { system, modules, nixpkgs ? defaultNixpkgs }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.armqr.nixosModules.default
        "${inputs.nixpkgs-akkoma}/nixos/modules/services/web-apps/akkoma.nix"
        self.nixosModules.astral
      ] ++ modules;

      specialArgs = { inherit inputs; };
    };

} // (import ./github-actions.nix { inherit lib; })
