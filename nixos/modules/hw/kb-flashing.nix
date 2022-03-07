{ qmk_firmware }:
let qmk-rules = "${qmk_firmware}/util/udev/50-qmk.rules";
in { config, lib, pkgs, ... }:
with lib; {
  options.astral.hw.kb-flashing.enable = mkOption {
    description = ''
      Enable all keyboard flashing functionality for this machine.

      Also see https://github.com/astralbijection/qmk_firmware
    '';
    default = false;
    type = types.bool;
  };

  config = mkIf config.astral.hw.kb-flashing.enable {
    environment.systemPackages = with pkgs; [ usbutils wally-cli ];

    # QMK rules
    services.udev.extraRules = builtins.readFile qmk-rules;

    # Ergodox
    hardware.keyboard.zsa.enable = true;
  };
}
