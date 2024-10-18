inputs:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  constants = import ./constants.nix;
in
{
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      # splashImage = ./nerd-emoji.jpg;
    };
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "uhci_hcd"
    "hpsa"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "tg3" # needed for initrd networking on this machine
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

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
        (pkgs.writeText "ssh_host_rsa_key" (builtins.readFile ./initrd/ssh_host_rsa_key))
        (pkgs.writeText "ssh_host_ed25519_key" (builtins.readFile ./initrd/ssh_host_ed25519_key))
      ];
      authorizedKeys = inputs.self.lib.sshKeyDatabase.users.astrid;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
}
