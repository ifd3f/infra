resource "libvirt_volume" "badtop_boot" {
  name   = "bootstrap-dev-badtop.qcow2"
  source = var.installer_path
}

resource "libvirt_domain" "badtop" {
  name        = "badtop.hv.astrid.tech"
  description = "Badtop analogue"
  memory      = 4000
  vcpu        = 2
  autostart   = false

  network_interface {
    network_name = libvirt_network.inner.name
  }

  disk {
    volume_id = libvirt_volume.nixos_installer[0].id
  }

  disk {
    volume_id = libvirt_volume.badtop_boot.id
    scsi = true
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
