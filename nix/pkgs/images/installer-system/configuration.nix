# Stolen from https://github.com/wagdav/homelab/blob/master/installer/iso.nix
# Also from https://hoverbear.org/blog/nix-flake-live-media/

# You can drop in a /wpa_supplicant.conf to connect to wifi headlessly!
self:
{
  lib,
  pkgs,
  modulesPath,
  ...
}:
with lib;
{
  imports = [ self.nixosModules.astral ];

  users.mutableUsers = false;

  # networking.supplicant."wlan0".configFile.path = "/wpa_supplicant.conf";

  services.openssh.settings.PermitRootLogin = mkForce "no";

  astral = {
    users.astrid.enable = true;
    net.sshd.enable = true;
    tailscale.enable = mkForce false;
  };
}
