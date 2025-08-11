# Customized /etc/issue file that updates with this system's IP.
{
  lib,
  config,
  pkgs,
  ...
}:
{
  systemd.services.update-custom-tty = {
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      python3
      iproute2
      coreutils
    ];
    script = ''
      ${./issue.py} > /var/issue
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
}
