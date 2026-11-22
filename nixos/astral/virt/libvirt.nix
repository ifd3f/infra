{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.virt.libvirt;
in
{
  options.astral.virt.libvirt = {
    enable = lib.mkEnableOption "astral.virt.libvirt";
    trustGuestNetwork = lib.mkOption {
      description = "Trust guests and the default guest network";
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "kvm-intel" ];
      binfmt.emulatedSystems = [ "aarch64-linux" ];
    };

    virtualisation.libvirtd.enable = true;

    networking.firewall.trustedInterfaces = lib.optionals cfg.trustGuestNetwork [ "virbr0" ];
  };
}
