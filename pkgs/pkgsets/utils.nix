{
  name = "Situational shell utilities";

  selector =
    ps:
    with ps;
    [
      binwalk
      caligula
      dasel
      ffmpeg
      fzf
      iftop
      lftp
      minicom
      mosh
      pinyin-tool
      restic
      scc
      screen
      sshpass
      wireguard-tools
    ]
    ++ lib.optionals ps.stdenv.hostPlatform.isLinux [
      iotop
      nfs-utils
      perf
      powertop
      strace-analyzer
      usbtop
    ];
}
