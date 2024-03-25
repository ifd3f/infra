inputs:
{ config, lib, ... }:
with lib;
let constants = import ./constants.nix;
in {
  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      # splashImage = ./nerd-emoji.jpg;
    };
  };

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ehci_pci" "uhci_hcd" "hpsa" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # because we want to be able to decrypt host keys over SSH
  boot.initrd.network = {
    enable = true;
    udhcpc.enable = true;
    postCommands = ''
      ip addr
    '';
    ssh = {
      enable = true;
      hostKeys = [ ./initrd/ssh_host_rsa_key ./initrd/ssh_host_ed25519_key ];
      authorizedKeys = inputs.self.lib.sshKeyDatabase.users.astrid;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    mkDefault config.hardware.enableRedistributableFirmware;
}
