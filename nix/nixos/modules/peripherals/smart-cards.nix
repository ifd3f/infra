{ pkgs, ... }:
{
  # smart cards
  services.pcscd = {
    enable = true;
    plugins = with pkgs; [
      ccid
      libacr38u
    ];
  };

  environment.systemPackages = with pkgs; [
    opensc
    pcsclite
    pcsctools
    yubico-piv-tool
    yubikey-personalization
    yubikey-personalization-gui
    yubioath-flutter
  ];
}
