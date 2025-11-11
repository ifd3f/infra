{
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    "${inputs.nixos-apple-silicon}/apple-silicon-support"

    "${inputs.self}/nix/nixos/modules/roles/pc"

    ./fs.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "nyacbook-nyair";
    hostId = "db699f52";
  };

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  system.stateVersion = "25.11";

  # TMP(2025-11-10) not work
  virtualisation.libvirtd.enable = mkForce false;

  # i don't know where this comes from but eh
  # - `hardware.graphics.enable32Bit` is only supported on an x86_64 system.
  hardware.graphics.enable32Bit = mkForce false;

  hardware.asahi.extractPeripheralFirmware = false;
}
