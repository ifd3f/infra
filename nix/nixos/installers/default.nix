{ inputs, system }:
let
  nixpkgs = inputs.nixpkgs-unstable;

  # TMP(2025-11-08): zfs isn't stable on 6.17 yet
  /*
    zfsOverlay =
      final: prev:
      let
        zfsVersion = "2.4.0-rc3";
        zfsSrc = final.fetchurl {
          url = "https://github.com/openzfs/zfs/archive/refs/tags/zfs-${zfsVersion}.tar.gz";
          sha256 = "";
        };
      in
      {
        zfs = prev.zfs.overrideAttrs {
          meta.broken = false;
          version = zfsVersion;
          src = zfsSrc;
        };

        linuxPackagesFor =
          args:
          let
            kprev = (prev.packagesFor args);
          in
          kprev
          // {
            zfs = kprev.zfs.overrideAttrs {
              meta.broken = false;
              version = zfsVersion;
              src = zfsSrc;
            };
          };
      };
  */

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
        nixpkgs.overlays = [
          inputs.nixos-apple-silicon.overlays.default
        ];
      }
    ];
  };
in
{
  apple-aarch64 = apple-aarch64.config.system.build.isoImage;
}
