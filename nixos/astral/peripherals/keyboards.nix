{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.peripherals.keyboards;
in
{
  options.astral.peripherals.keyboards = {
    enable = lib.mkEnableOption "astral.peripherals.keyboards";
  };

  config = lib.mkIf cfg.enable {
    # keyboards
    environment.systemPackages = with pkgs; [
      usbutils
      wally-cli
    ];
    services.udev.packages = [ pkgs.qmk-udev-rules ]; # ergodox
  };
}
