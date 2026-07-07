{
  description = "Graphical development tools";

  selector =
    ps:
    with ps;
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      ghidra
      virt-manager
      vscode
      wireshark
    ];
}
