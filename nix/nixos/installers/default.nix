{ inputs, system }:
{
  # yoinkage from https://github.com/nix-community/nixos-apple-silicon/blob/e01011ebc0aa7a0ae6444a8429e91196addd45f4/flake.nix#L61
  apple-aarch64 =
    let
      nixpkgs = inputs.nixos-apple-silicon.inputs.nixpkgs;
      installer-system = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
          modulesPath = nixpkgs + "/nixos/modules";
        };

        modules = [
          "${inputs.nixos-apple-silicon}/iso-configuration"
          {
            hardware.asahi.pkgsSystem = system;

            # make sure this matches the post-install
            # `hardware.asahi.pkgsSystem`
            nixpkgs.hostPlatform.system = "aarch64-linux";
            nixpkgs.buildPlatform.system = system;
            nixpkgs.overlays = [ inputs.nixos-apple-silicon.overlays.default ];
          }
          ./apple-aarch64.nix
        ];
      };
    in
    installer-system.config.system.build.isoImage;
}
