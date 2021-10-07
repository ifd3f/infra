{
  systemd.services."ensure-libvirt-state" = {
    description = "Ensure directory for Libvirt state exists";
    script = ''
      mkdir -p /persist/var/lib/libvirt
    '';
    wantedBy = [ "var-lib-libvirt.mount" ];
    serviceConfig = { Type = "oneshot"; };
  };

  systemd.services."ensure-docker-state" = {
    description = "Ensure directory for Docker state exists";
    script = ''
      mkdir -p /persist/var/lib/docker
    '';
    wantedBy = [ "var-lib-docker.mount" ];
    serviceConfig = { Type = "oneshot"; };
  };

  # Unfortunately, libvirt doesn't like symlinks to /var/lib/libvirt, but it's
  # okay with bind mounts.
  fileSystems."/var/lib/libvirt" = {
    device = "/persist/var/lib/libvirt";
    options = [ "bind" ];
  };

  fileSystems."/var/lib/docker" = {
    device = "/persist/var/lib/docker";
    options = [ "bind" ];
  };

  systemd.services."ensure-network-manager-state" = {
    description = "Ensure directory for NetworkManager state exists";
    script = ''
      mkdir -p /persist/etc/NetworkManager
    '';
    wantedBy = [ "etc-networkmanager.mount" ];
    serviceConfig = { Type = "oneshot"; };
  };
  fileSystems."/etc/NetworkManager" = {
    device = "/persist/etc/NetworkManager";
    options = [ "bind" ];
  };
  systemd.services."ensure-sshd-dirs" = {
    description = "Ensure directory for SSHD host keys exists";
    script = ''
      mkdir -p /persist/etc/ssh/
    '';
    wantedBy = [ "sshd.service" ];
    serviceConfig = { Type = "oneshot"; };
  };

  services.openssh = {
    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

}
