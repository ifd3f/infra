{ ... }: {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "yes";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;
}
