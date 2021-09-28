{ pkgs, ... }:
{
  boot.kernelModules = [ "kvm-intel" ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemuOvmf = true;
    };
    docker = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    netcat # For qemu+ssh:// connections
    docker-compose # For raw, non-k8s docker
  ];

  networking.interfaces."br0".useDHCP = true;
  networking.bridges."br0".interfaces = [
    "eno1"
  ];
}
