inputs:
{ config, pkgs, lib, modulesPath, ... }:
let rootFSUID = "5a713012-c18f-4b4f-b900-137c5739c854";
in with lib; {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.self.nixosModules.server
  ];

  services.qemuGuest.enable = true;

  astral = {
    tailscale.enable = mkForce false;
    monitoring-node.scrapeTransport = "https";
  };

  networking = {
    hostName = "thatcher";
    domain = "h.astrid.tech";
  };

  fileSystems."/" = mkForce {
    device = "/dev/disk/by-uuid/${rootFSUID}";
    autoResize = true;
    fsType = "ext4";
  };

  boot = {
    growPartition = true;
    kernelParams = [ "console=tty0" "boot.shell_on_fail" ];
    loader.grub.device = "/dev/vda";
    loader.timeout = 3;
  };

  system.build.raw = mkForce
    (import "${toString modulesPath}/../lib/make-disk-image.nix" {
      inherit lib config pkgs rootFSUID;
      name = "thatcher-disk-image";
      label = "root";
      diskSize = "auto";
      format = "raw";
      copyChannel = false;
    });

  # This script reproduces, as close as possible, the conditions of the actual machine.
  # This is useful for testing if the wget -O- | dd of=/dev/vda will work.
  system.build.test-simple-vm = pkgs.writeShellScriptBin "test-simple-vm" ''
    set -euxo pipefail
    dd bs=1M if=${config.system.build.raw}/nixos.img of=test.raw status=progress
    truncate -s 8G test.raw
    ${pkgs.qemu}/bin/qemu-kvm \
      -smp 2 \
      -m 2G \
      -drive if=virtio,format=raw,file=test.raw \
      -netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9,hostfwd=tcp::2222-:22 \
      -net nic,model=e1000,macaddr=00:20:91:84:25:7f,netdev=mynet0
  '';

  time.timeZone = "US/Pacific";
}
