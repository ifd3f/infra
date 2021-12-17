{ pkgs, ... }: {
  boot.kernelModules = [ "kvm-intel" ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };
    docker = { enable = true; };
  };

  environment.systemPackages = with pkgs; [
    netcat # For qemu+ssh:// connections
    docker-compose # For raw, non-k8s docker
  ];
}
