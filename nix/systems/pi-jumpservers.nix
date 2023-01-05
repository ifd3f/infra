{ self, nixpkgs-stable, ... }:
let
  mkPiJumpservers = builtins.mapAttrs (hostName: moduleExtra:
    (self.lib.nixosSystem' {
      nixpkgs = nixpkgs-stable;
      system = "aarch64-linux";
      modules = [
        ({ pkgs, ... }: {
          imports = [
            "${nixpkgs-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            self.nixosModules.server
          ];

          astral = {
            virt = {
              docker.enable = false;
              libvirt.enable = false;
              lxc.enable = false;
            };
          };

          # Don't compress the image.
          sdImage.compressImage = false;
        })
        moduleExtra
      ];
    }));
in mkPiJumpservers {
  jonathan-js = { time.timeZone = "US/Pacific"; };
  joseph-js = { time.timeZone = "US/Pacific"; };
}
