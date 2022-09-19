{ self, nixpkgs }:
let
  mkPiJumpservers = builtins.mapAttrs (hostName: moduleExtra:
    (self.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ({ pkgs, ... }: {
          imports = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ];

          astral = {
            roles.server.enable = true;
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
