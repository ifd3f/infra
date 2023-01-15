{ self, defaultNixpkgs, inputs, system ? null }:
let inherit (inputs.nixpkgs-unstable) lib;
in rec {
  sshKeyDatabase = import ../../ssh_keys;

  ci = import ../ci.nix { inherit self lib; };

  nixosSystem' = { system, modules, nixpkgs ? defaultNixpkgs }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.armqr.nixosModules.default
        inputs.year-of-bot.nixosModules.default
        inputs.blurred-horse-bot.nixosModules.default
        inputs.catgpt.nixosModules.default
        inputs.nur-ifd3f.nixosModules.pleroma-ebooks
        self.nixosModules.astral
      ] ++ modules;

      specialArgs = { inherit inputs; };
    };

} // (import ./github-actions.nix { inherit lib; })
