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
    pcsc-tools
    yubico-piv-tool
    yubikey-personalization
    yubioath-flutter
  ];
}
