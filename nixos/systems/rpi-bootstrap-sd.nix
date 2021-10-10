# See https://nixos.wiki/wiki/NixOS_on_ARM

{ self, nixpkgs-unstable, ... }:
let
  nixpkgs = nixpkgs-unstable;
  specialized = {
    imports = [
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    ];

    # Don't compress the image.
    sdImage.compressImage = false;
    
    # Import Astrid's keys so it can be managed headlessly.
    users.extraUsers.root.openssh.authorizedKeys.keys = (import ../../ssh_keys).astrid;
  };
in nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";

  modules = with self.nixosModules; [
    specialized
    sshd
    debuggable
    stable-flake
  ];
}
