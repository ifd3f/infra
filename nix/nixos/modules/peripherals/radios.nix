{ config, lib, ... }:
let
  cfg = config.astral.peripherals.radios;
in
{
  options.astral.peripherals.radios = {
    enable = lib.mkEnableOption "astral.peripherals.radios";
  };

  config = lib.mkIf cfg.enable {
    hardware.hackrf.enable = true;
    hardware.rtl-sdr.enable = true;
    services.sdrplayApi.enable = true;
  };
}
