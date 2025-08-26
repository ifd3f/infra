# Situational shell utilities.
{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.perf

    binwalk
    caligula
    dasel
    ffmpeg
    fzf
    iftop
    iotop
    lftp
    minicom
    mosh
    nfs-utils
    powertop
    restic
    scc
    screen
    sshpass
    strace-analyzer
    usbtop
    wireguard-tools
  ];
}
