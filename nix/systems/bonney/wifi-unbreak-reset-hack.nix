# The 7260 card randomly dies for stupid reasons. A janky workaround is to
# simply force-reset it every few minutes to unbreak it.
{ pkgs, ... }:
let
  pciaddr = "0000:02:00.0";
  pcidir = "/sys/bus/pci/devices/${pciaddr}";
in {
  systemd.services."wifi-unbreak-reset-hack" = {
    description = "A really stupid workaround for a really shitty wifi card";
    path = with pkgs; [ coreutils iproute2 kmod ];
    script = ''
      set -uxo pipefail

      ip l set wlp2s0 down
      modprobe -r iwlmvm
      modprobe -r iwlwifi

      set -e
      echo 1 > /sys/bus/pci/rescan
      sleep 1
      echo 1 > ${pcidir}/reset
      sleep 1
      echo 1 > ${pcidir}/remove
      sleep 1
      echo 1 > /sys/bus/pci/rescan
      sleep 1

      modprobe iwlwifi
      modprobe iwlmvm
      ip l set wlp2s0 up
    '';
    serviceConfig.Type = "oneshot";
  };

  systemd.timers."wifi-unbreak-reset-hack" = {
    description = "A really stupid workaround for a really shitty wifi card";
    wantedBy = [ "multi-user.target" ];
    timerConfig.OnCalendar = "*:0/2"; # Every 2 minutes
  };

  environment.systemPackages = with pkgs; [ tcpdump ];
}
