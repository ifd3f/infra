{ self, nixpkgs-unstable, home-manager-unstable, ... }:
{ pkgs, ... }: {
  imports = with self.nixosModules; [
    "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    home-manager-unstable.nixosModules.home-manager

    bm-server
    debuggable
    sshd
    stable-flake
  ];

  nix.settings.auto-optimise-store = true;

  environment.systemPackages = [
    pkgs.wakelan # wake me up inside
  ];

  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.astrid = self.homeModules.astrid_cli_full;
  };

  users.users.astrid = import ../users/astrid.nix // { shell = pkgs.zsh; };
}
