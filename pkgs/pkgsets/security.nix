{
  description = "Security";

  selector =
    ps:
    with ps;
    [ yubikey-manager ]
    ++ lib.optionals ps.stdenv.hostPlatform.isLinux [
      tpm2-tools
      tpm2-tss
    ];
}
