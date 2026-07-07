{
  name = "Security";

  selector =
    ps: with ps; [
      tpm2-tools
      tpm2-tss
      yubikey-manager
    ];
}
