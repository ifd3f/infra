# Stolen from https://github.com/wagdav/homelab/blob/master/installer/iso.nix
# Also from https://hoverbear.org/blog/nix-flake-live-media/

# You can drop in a /wpa_supplicant.conf to connect to wifi headlessly!

{ lib, pkgs, modulesPath, ... }:
with lib; {
  imports = [
    # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  users.mutableUsers = false;
  
  networking.supplicant."wlan0".configFile.path = "/wpa_supplicant.conf";

  services.openssh.settings.PermitRootLogin = mkForce "no";

  astral = {
    users.astrid.enable = true;
    net.sshd.enable = true;
    tailscale.enable = mkForce false;
  };
}
