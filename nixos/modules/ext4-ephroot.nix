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
    boot.initrd.kernelModules = [ "ext4" ];

    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkfs.ext4 -F ${cfg.partition}
    '';
  };
}
