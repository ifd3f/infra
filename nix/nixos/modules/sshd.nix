{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.sshd;
in
{
  options.astral.sshd = {
    enable = lib.mkEnableOption "astral.sshd";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # Open ports in the firewall.
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}
