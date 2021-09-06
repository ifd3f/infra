# https://grahamc.com/blog/erase-your-darlings but / is ext4
{ pkgs, lib, config, ... }:
let cfg = config.ext4-ephroot;
in
{
  options.ext4-ephroot = with lib; {
    partition = mkOption {
      description = "The root partition you want to wipe every boot.";
      type = types.str;
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      e2fsprogs
    ];

    boot.initrd.postDeviceCommands = lib.mkAfter ''
      ${pkgs.e2fsprogs}/sbin/mkfs.ext4 -F ${cfg.partition}
    '';
  };
}
