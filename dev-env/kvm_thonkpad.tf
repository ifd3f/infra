# Boot disk
resource "libvirt_volume" "thonkpad_boot" {
  name = "bootstrap-dev-thonkpad-boot.qcow2"
  size = 30 * 1024 * 1024 * 1024
}

resource "libvirt_domain" "thonkpad" {
  name        = "thonkpad.hv.astrid.tech"
  description = "Thonkpad analogue"
  memory      = 2000
  vcpu        = 2
  autostart   = false

  network_interface {
    network_name = libvirt_network.inner.name
  }

  disk {
    volume_id = libvirt_volume.nixos_installer[3].id
  }

  disk {
    volume_id = libvirt_volume.thonkpad_boot.id
    scsi = true
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
