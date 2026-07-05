# Situational shell utilities.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.utils;
in
{
  options.astral.program-sets.utils = {
    enable = lib.mkEnableOption "astral.program-sets.utils";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
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
  };
}
