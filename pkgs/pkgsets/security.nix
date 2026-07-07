{
  description = "Security";

  selector =
    ps:
    with ps;
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      tpm2-tools
      tpm2-tss
      yubikey-manager
    ];
}
