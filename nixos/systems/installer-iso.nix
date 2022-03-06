# Stolen from https://github.com/wagdav/homelab/blob/master/installer/iso.nix
# Also from https://hoverbear.org/blog/nix-flake-live-media/

# TODO make it a lot better
{ mkSystem, nixosModules, nixpkgs, ... }:
let
  specialized = { config, pkgs, system ? builtins.currentSystem, ... }: {
    imports = [
      # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ];

    systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
    users = {
      mutableUsers = false;
      users.nixos = {
        openssh.authorizedKeys.keys = (import ../../ssh_keys).astrid;
      };
    };

    services = {
      openssh = {
        enable = true;
        passwordAuthentication = false;
        permitRootLogin = "yes";
      };
    };
  };
in mkSystem {
  hostName = "astral-nixos-installer";
  modules = with nixosModules; [ specialized ];
}
