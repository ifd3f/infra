{ self, defaultNixpkgs, inputs, system ? null }:
let inherit (inputs.nixpkgs-unstable) lib;
in rec {
  ifd3f-ca = import ../../ca { inherit lib; };
  sshKeyDatabase = import ../../ssh_keys;

  ci = import ../ci.nix { inherit self lib; };

  nixosSystem' = { system, modules, nixpkgs ? defaultNixpkgs }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.vault-secrets.nixosModules.vault-secrets
        inputs.armqr.nixosModules.default
        inputs.akkoma-exporter.nixosModules.default
        inputs.year-of-bot.nixosModules.default
        inputs.blurred-horse-bot.nixosModules.default
        inputs.catgpt.nixosModules.default
        inputs.googlebird.nixosModules.default
        inputs.nur-ifd3f.nixosModules.pleroma-ebooks
        self.nixosModules.astral
      ] ++ modules;

      specialArgs = { inherit inputs; };
    };

} // (import ./github-actions.nix { inherit lib; })
