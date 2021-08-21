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
        # (import ../keys.nix).astrid 
        "ssh-rsa AAAAB4NzaC1yc2EAAAADAQABAAABAQDc79RQW1memuqUUT7vYBKHBZ+h+BcjgCu0vvwgLLBwwJ3yBgU7wFx0EUkmfsg3icXhfiH61Bt7J4/eOm/sAE39oAcEZkv6xXgzwhMnWBWjAFcM5Ai3yvQJKxHVTkRXwyajf14HCQ594o0uLz0SGmoMvVkgBetdugRkvaYULdwgrqPt0302pEw1cKfUifeRqFnGVLcllXJV1iWqvuODfJTUO4tTlEIRSLcojaEfDVHM+9/Xx6tqFNeDxrRWd4VIf0vLbirCF8AzqzkYGjV9CL0Ao1l6serdLGZDtkpdd8gK5QQ1PNBqQPvMo+1p3Wq76Jy6dSax08GTdnG6/REUsWo3 astrid@BANANA"
      ];
    };
  };

  environment.etc = {
    # "install.sh" = {
    #   source = ./install.sh;
    #   mode = "0700";
    # };

    "configuration.nix" = {
      source = ./configuration.nix;
      mode = "0600";
    };
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = true;
      permitRootLogin = "yes";
    };
  };
}