{
  name = "security";
  description = "Security/encryption tools";
  progFn = { pkgs }: {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    environment.systemPackages = with pkgs; [
      pinentry
      tor-browser-bundle-bin
      (hashcat.override { cudaSupport = true; })
    ];
  };
}
