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
      
      users.extraUsers.root.openssh.authorizedKeys.keys = (import ../keys.nix).astrid;
    }
    (import ../modules/sshd.nix)
  ];
}
