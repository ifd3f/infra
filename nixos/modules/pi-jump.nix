{ self, nixpkgs-unstable, ... }:
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wakelan # wake me up inside
  ];

  imports = with self.nixosModules; [
    "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    bm-server
    debuggable
    sshd
    stable-flake
  ];

  users.users.astrid = import ../users/astrid.nix;
}