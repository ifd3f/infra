# Raspberry Pi 4 running as an IoT gateway
{ pkgs, lib, inputs, ... }: {
  imports = [
    "${inputs.nixpkgs-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    inputs.self.nixosModules.server

    inputs.self.nixosModules.iot-gw
  ];

  networking = {
    hostName = "ghoti";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";
}
