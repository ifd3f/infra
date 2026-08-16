{
  description = "Security and cryptography utilities";

  selector =
    ps:
    with ps;
    [
      age
      openssl
      yubikey-manager
    ]
    ++ lib.optionals ps.stdenv.hostPlatform.isLinux [
      tpm2-tools
      tpm2-tss
    ];
}
