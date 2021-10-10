# See https://nixos.wiki/wiki/NixOS_on_ARM

{ self, nixpkgs-unstable, ... }:
let
  nixpkgs = nixpkgs-unstable;
in nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";

  modules = [
    {
      imports = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ];

      # Don't compress the image.
      sdImage.compressImage = false;
      
      # Import Astrid's keys so it can be managed headlessly.
      users.extraUsers.root.openssh.authorizedKeys.keys = (import ../keys.nix).astrid;
    }
    (import ../modules/sshd.nix)
  ];
}
