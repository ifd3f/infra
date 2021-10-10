{ self, nixpkgs-unstable, ... }:
{ pkgs, ... }:
{
  imports = with self.nixosModules; [
    "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    bm-server
    sshd
    debuggable
  ];

  users.users.astrid = import ../users/astrid.nix;
}