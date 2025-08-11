# These config options are common to EVERYTHING.
{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.lix-module.nixosModules.default

    "${inputs.self}/nix/nixos/modules/program-sets/basics.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/utils.nix"

    "${inputs.self}/nix/nixos/modules/custom-tty"
    "${inputs.self}/nix/nixos/modules/mount-root-to-home.nix"
    "${inputs.self}/nix/nixos/modules/nix-utils.nix"
    "${inputs.self}/nix/nixos/modules/sshd.nix"
    "${inputs.self}/nix/nixos/modules/users.nix"
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
