{ pkgs, ... }:
{
  systemd.services."ensure-libvirt-state" = {
    description = "Ensure directory for libvirt state exists";
    script = ''
      mkdir -p /persist/var/lib/libvirt
    '';
    wantedBy = [ "var-lib-libvirt.mount" ];
    serviceConfig = {
      Type = "oneshot";
    };
  };

  # Unfortunately, libvirt doesn't like symlinks to /var/lib/libvirt, but it's
  # okay with bind mounts.
  fileSystems."/var/lib/libvirt" = {
    device = "/persist/var/lib/libvirt";
    options = [ "bind" ];
  };

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
