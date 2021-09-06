{ ... }:
{
  systemd.services."ensure-sshd-dirs" = {
    description = "Ensure directory for SSHD host keys exists";
    script = ''
      mkdir -p /persist/etc/ssh/
    '';
    wantedBy = [ "sshd.service" ];
    serviceConfig = {
      Type = "oneshot";
    };
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "yes";

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
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;
}
