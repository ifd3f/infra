{ pkgs, ... }:
{
  boot.kernelModules = [ "kvm-intel" ];

  virtualisation.libvirtd = {
    enable = true;
  };

  # For qemu+ssh:// connections
  environment.systemPackages = with pkgs; [
    netcat
  ];
}
