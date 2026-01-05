{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.peripherals.smart-cards;
in
{
  options.astral.peripherals.smart-cards = {
    enable = lib.mkEnableOption "astral.peripherals.smart-cards";
  };

  config = lib.mkIf cfg.enable {
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
  };
}
