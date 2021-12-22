{ self, nixpkgs-unstable, ... }:
let nixpkgs = nixpkgs-unstable;
in {
  imports = with self.nixosModules; [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

    bm-server
    debuggable
    flake-update
    octoprint-full
    stable-flake
    wireguard-client
  ];

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "cuttlefish";
    domain = "id.astrid.tech";
  };

  services.octoprint-full.host = "cuttlefish";

  sdImage.compressImage = false;
}

