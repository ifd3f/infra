{ pkgs, ... }: {
  environment.systemPackages =
    [ usbutils wally-cli ];

  # For flashing Ergodoxes
  hardware.keyboard.zsa.enable = true;

  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };
}
