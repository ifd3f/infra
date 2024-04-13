inputs:
{ config, lib, pkgs, ... }:
let constants = import ./constants.nix;
in {
  boot.initrd.availableKernelModules = [
    "ehci_pci"
    "ata_piix"
    "mpt3sas"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "e1000e" # initrd networking
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # legacy boot moment
  boot.loader.grub.devices = [
    "/dev/disk/by-id/usb-Generic_Flash_Disk_5AF232B0-0:0"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # because we want to be able to decrypt host keys over SSH
  boot.initrd.network = {
    enable = true;
    udhcpc = {
      enable = true;
      extraArgs = [
        "-i"
        constants.mgmt_if
        "-x"
        "hostname:boop"
        "-b" # background if lease not obtained
      ];
    };
    postCommands = ''
      ip addr
    '';
    ssh = {
      enable = true;
      port = 2222; # because we are using a different host key
      hostKeys = [
        (pkgs.writeText "ssh_host_rsa_key"
          (builtins.readFile ./initrd/ssh_host_rsa_key))
        (pkgs.writeText "ssh_host_ed25519_key"
          (builtins.readFile ./initrd/ssh_host_ed25519_key))
      ];
      authorizedKeys = inputs.self.lib.sshKeyDatabase.users.astrid;
    };
  };
}

