{
  description = "Situational shell utilities";

  selector =
    ps:
    with ps;
    [
      caligula
      dasel
      exfat
      ffmpeg
      gh
      iftop
      lftp
      minicom
      mosh
      nixfmt
      ntfs3g
      openssl
      p7zip
      pinyin-tool
      rustic
      scc
      screen
      speedtest-rs
      sshpass
      wireguard-tools
    ]
    ++ lib.optionals ps.stdenv.hostPlatform.isLinux [
      beep
      dmidecode
      fatresize
      iotop
      nfs-utils
      perf
      powertop
      strace-analyzer
      usbtop
      xorriso
    ];
}
