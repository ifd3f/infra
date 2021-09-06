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

  # Enable flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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

  # In terms of packages, the installer should be lightweight but still have enough
  # tools so that debugging things is comfortable.
  environment.systemPackages = with pkgs; [
    # Editors are always helpful
    neovim

    # Download stuff from the internet
    git
    curl
    wget

    # Just in case the SSH connection is lost and I'm running something long
    tmux

    # Useful scripting utilities
    envsubst
    tree
    jq
    yq
  ];
}
