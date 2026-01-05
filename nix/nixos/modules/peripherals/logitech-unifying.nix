{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.peripherals.logitech-unifying;
in
{
  options.astral.peripherals.logitech-unifying = {
    enable = lib.mkEnableOption "astral.peripherals.logitech-unifying";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ solaar ];
    hardware.logitech.wireless.enable = true;
  };
}
