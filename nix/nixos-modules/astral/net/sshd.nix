{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.astral.net.sshd.enable = mkOption {
    description = "Enable to use customized sshd configs.";
    default = true;
    type = types.bool;
  };

  config =
    let
      cfg = config.astral.net.sshd;
    in
    mkIf cfg.enable {
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
