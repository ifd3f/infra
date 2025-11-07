{ inputs, system }:
let
  nixpkgs = inputs.nixpkgs-stable;

  # yoinkage from https://github.com/nix-community/nixos-apple-silicon/blob/e01011ebc0aa7a0ae6444a8429e91196addd45f4/flake.nix#L61
  apple-aarch64 = nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit inputs;
      modulesPath = nixpkgs + "/nixos/modules";
    };

    modules = [
      ./apple-aarch64.nix
      {
        hardware.asahi.pkgsSystem = system;

        # make sure this matches the post-install
        # `hardware.asahi.pkgsSystem`
        nixpkgs.hostPlatform.system = "aarch64-linux";
        nixpkgs.buildPlatform.system = system;
        nixpkgs.overlays = [ inputs.nixos-apple-silicon.overlays.default ];
      }
    ];
  };
in
{
  apple-aarch64 = apple-aarch64.config.system.build.isoImage;
}
