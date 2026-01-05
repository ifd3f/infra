{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.peripherals.rgb;
in
{
  options.astral.peripherals.rgb = {
    enable = lib.mkEnableOption "astral.peripherals.rgb";
  };

  config = lib.mkIf cfg.enable {
    # RGB stuff
    hardware.i2c.enable = true;
    environment.systemPackages = with pkgs; [ openrgb ];
  };
}
