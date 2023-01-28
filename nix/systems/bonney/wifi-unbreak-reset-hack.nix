# The 7260 card randomly dies for stupid reasons. A janky workaround is to
# simply force-reset it every few minutes to unbreak it.
let
  pciaddr = "0000:02:00.0";
  pcidir = "/sys/bus/pci/devices/${pciaddr}";
in {
  systemd.services."wifi-unbreak-reset-hack" = {
    description = "A really stupid workaround for a really shitty wifi card";
    script = ''
      echo 1 > ${pcidir}/reset
    '';
  };
  systemd.timers."wifi-unbreak-reset-hack" = {
    description = "A really stupid workaround for a really shitty wifi card";
    wantedBy = [ "multi-user.target" ];
    timerConfig.OnCalendar = "*:0/2"; # Every 2 minutes
  };
}
