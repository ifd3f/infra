/* Customized /etc/issue file that updates with
   this system's IP.
*/
{ lib, config, pkgs, ... }: {
  options.astral.custom-tty = with lib; {
    enable = mkOption {
      description = "A custom /etc/issue generator to make a tty login prompt.";
      default = false;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.custom-tty;
  in lib.mkIf cfg.enable {
    systemd.services.update-custom-tty = {
      wantedBy = [ "multi-user.target" ];
      script = with pkgs;
        let path = lib.makeBinPath [ iproute2 coreutils ];
        in ''
          PATH=${path} ${python3}/bin/python3 ${./issue.py} > /var/issue
        '';
    };

    systemd.timers.update-custom-tty = {
      wantedBy = [ "multi-user.target" ];
      timerConfig.OnCalendar = "*-*-* *:*:00";
    };

    environment.etc."issue" = lib.mkOverride 10 {
      source = pkgs.runCommand "var-issue-symlink" { } ''
        ln -s /var/issue $out
      '';
    };
  };
}
