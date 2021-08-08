source "qemu" "vyos" {
  iso_url           = "https://s3.amazonaws.com/s3-us.vyos.io/snapshot/vyos-1.3.0-rc4/qemu/vyos-1.3.0-rc4-qemu.qcow2"
  iso_checksum      = "245b99c2ee92a0446cc5a24f5e169b06a6a0b1dd255badfb4a8771b2bfd4c9dd"
  memory            = "1024"
  output_directory  = "images"
  shutdown_command  = "sudo shutdown now"
  disk_size         = "8G"
  disk_image        = true
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "http"
  ssh_username      = "vyos"
  ssh_password      = "vyos"
  ssh_timeout       = "20m"
  vm_name           = "vyos.qcow2"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_key_interval = "20ms"
  boot_wait         = "1s"
  boot_command      = [
    "<enter><wait20>",  # skip grub
    "vyos<enter><wait>",  # login credentials
    "vyos<enter><wait>",

    "configure<enter>",
    "set interface ethernet eth0 address dhcp<enter>",
    "set service ssh<enter>",
    "commit<enter>",
    "save<enter>",
    "exit<enter>"
  ]
}

build {
  sources = ["source.qemu.vyos"]

  provisioner "file" {
    source = "${path.root}/config.sh"
    destination = "/tmp/config.sh"
  }

  provisioner "shell" {
    inline = [
      "bash /tmp/config.sh"
    ]
  }
}