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
    nfs-utils
    powertop
    restic
    scc
    sshpass
    usbtop
    wireguard-tools
  ];
}
