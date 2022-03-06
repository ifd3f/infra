{ pkgs, ... }: {
  environment.systemPackages =
    [ usbutils wally-cli ];

  # For flashing Ergodoxes
  hardware.keyboard.zsa.enable = true;
}
