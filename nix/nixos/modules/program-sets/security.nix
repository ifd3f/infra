{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    opensc
    pcsclite
    pcsctools
    tpm2-tools
    tpm2-tss
    yubico-piv-tool
    yubikey-personalization
    yubikey-personalization-gui
    yubioath-flutter
  ];
}
