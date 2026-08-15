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

    # TODO: disabled as of 2026-08-15 for not working
    # services.sdrplayApi.enable = true;
  };
}
