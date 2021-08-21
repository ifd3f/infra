# Boot disk
resource "libvirt_volume" "cracktop_boot" {
  name = "bootstrap-dev-cracktop-boot.qcow2"
  size = 30 * 1024 * 1024 * 1024
}

resource "libvirt_domain" "cracktop" {
  name        = "cracktop.hv.astrid.tech"
  description = "Cracktop analogue"
  memory      = 2000
  vcpu        = 2
  autostart   = false
  firmware    = local.uefi_firmware

  network_interface {
    network_name = libvirt_network.inner.name
  }

  disk {
    volume_id = libvirt_volume.nixos_installer[2].id
  }

  disk {
    volume_id = libvirt_volume.cracktop_boot.id
    scsi = true
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
