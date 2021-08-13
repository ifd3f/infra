source "qemu" "vyos" {
  iso_url           = "https://s3.amazonaws.com/s3-us.vyos.io/snapshot/vyos-1.3.0-rc5/vyos-1.3.0-rc5-amd64.iso"
  iso_checksum      = "245b99c2ee92a0446cc5a24f5e169b06a6a0b1dd255badfb4a8771b2bfd4c9dd"
  memory            = "1024"
  output_directory  = "${path.root}/images"
  shutdown_command  = "sudo shutdown now"
  disk_size         = "3G"
  format            = "qcow2"
  accelerator       = "kvm"
  ssh_username      = "vyos"
  ssh_password      = "vyos"
  ssh_timeout       = "20m"
  vm_name           = "edgefw.qcow2"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_key_interval = "20ms"
  boot_wait         = "1s"
  boot_command      = [
    "<enter><wait25>",  # skip grub
    "vyos<enter><wait>",  # login credentials
    "vyos<enter><wait>",

    # Connect to the internet
    "configure<enter>",
    "set interface ethernet eth0 address dhcp<enter>",
    "set service ssh<enter>",
    "commit<enter>",
    "save<enter>",
    "exit<enter>",

    # Perform the install
    "install image<enter>",
    "<enter><wait>",  # Would you like to continue? (Yes/No) [Yes]:
    "<enter><wait>",  # Partition (Auto/Parted/Skip) [Auto]
    "<enter><wait>",  # Install the image on? [sda]
    "Yes<enter><wait>",  # Continue? (Yes/No) [No]: Yes
    "<enter><wait10>",  # How big of a root partition should I create? (2000MB - 4294MB) [4294]MB:
    "edgefw<enter><wait>", # What would you like to name this image? [1.2.0-rolling+201809210337]:
    "<enter><wait5>",  # Which one should I copy to sda? [/opt/vyatta/etc/config.boot.default]:
    "vyos<enter>",  # Enter password for user 'vyos':
    "vyos<enter>",  # Retype password for user 'vyos':
    "<enter><wait10>",  # Which drive should GRUB modify the boot partition on? [sda]:

    # Reboot
    "reboot<enter><wait>y<enter><wait10>",
  ]
}

build {
  sources = ["source.qemu.vyos"]

  provisioner "shell" {
    script = "${path.root}/config.sh"
  }
}