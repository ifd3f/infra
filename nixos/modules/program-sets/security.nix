{ pkgs, ... }: {
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = [
    bitwarden
    pinentry
    veracrypt
  ];
}
