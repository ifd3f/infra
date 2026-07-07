{
  name = "Situational shell utilities";

  selector =
    ps: with ps; [
      perf
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
      pinyin-tool
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
