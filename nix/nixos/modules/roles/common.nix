# These config options are common to EVERYTHING.
{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    "${inputs.self}/nix/nixos/modules/program-sets/basics.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/utils.nix"

    "${inputs.self}/nix/nixos/modules/mount-root-to-home.nix"
    "${inputs.self}/nix/nixos/modules/sshd.nix"
    "${inputs.self}/nix/nixos/modules/users.nix"
  ];
}
