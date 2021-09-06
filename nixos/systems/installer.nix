# Stolen from https://github.com/wagdav/homelab/blob/master/installer/iso.nix
# Also from https://hoverbear.org/blog/nix-flake-live-media/

{ self, nixpkgs }: nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [
    (
      { config, pkgs, system ? builtins.currentSystem, ... }:
      {
        imports = [
          # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
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
    )
  ];
}
