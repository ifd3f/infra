{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
with lib;
let
  rootFSUID = "3c5ade1a-d1a4-488c-b524-bc96c451b24c";
in
{
  _class = "nixos";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/${rootFSUID}";
    fsType = "ext4";
    autoResize = true;
  };

  system.build.raw = mkForce (
    import "${toString modulesPath}/../lib/make-disk-image.nix" {
      inherit
        lib
        config
        pkgs
        rootFSUID
        ;
      name = "diluc-disk-image";
      label = "root";
      diskSize = "auto";
      format = "raw";
      copyChannel = false;
    }
  );
}
