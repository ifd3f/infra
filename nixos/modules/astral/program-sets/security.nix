{
  name = "security";
  description = "Security/encryption tools";
  progFn = { pkgs }: {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.tor.enable = true;

    environment.systemPackages = with pkgs; [ pinentry tor-browser-bundle-bin ];
  };
}
