# Stolen from https://github.com/wagdav/homelab/blob/master/installer/iso.nix

{ config, pkgs, system ? builtins.currentSystem, ... }:
{
  imports = [
    # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users = {
    mutableUsers = false;
    users.nixos = {
      openssh.authorizedKeys.keys = [ 
        (import ../keys.nix).astrid 
      ];
    };
  };

  environment.etc = {
    "configuration.nix" = {
      source = ./configuration.nix;
      mode = "0600";
    };
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "yes";
    };
  };
}