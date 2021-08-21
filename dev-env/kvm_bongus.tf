# Boot disk
resource "libvirt_volume" "bongus_boot" {
  name = "bootstrap-dev-bongus-boot.qcow2"
  size = 30 * 1024 * 1024 * 1024
}

# Data disk 0
resource "libvirt_volume" "bongus_d0" {
  name = "bootstrap-dev-bongus-data-0.qcow2"
  size = 10 * 1024 * 1024 * 1024
}

# Data disk 1
resource "libvirt_volume" "bongus_d1" {
  name = "bootstrap-dev-bongus-data-1.qcow2"
  size = 10 * 1024 * 1024 * 1024
}

resource "libvirt_domain" "bongus" {
  name        = "bongus.hv.astrid.tech"
  description = "Bongus analogue"
  memory      = 6000
  vcpu        = 4
  autostart   = false

  network_interface {
    network_name = libvirt_network.outer.name
  }

  network_interface {
    network_name = libvirt_network.inner.name
  }

  network_interface {
    network_name = libvirt_network.inner.name
  }

  network_interface {
    network_name = libvirt_network.inner.name
  }

  disk {
    volume_id = libvirt_volume.nixos_installer[1].id
  }

  disk {
    volume_id = libvirt_volume.bongus_boot.id
    scsi = true
  }

  disk {
    volume_id = libvirt_volume.bongus_d0.id
    scsi = true
  }

  disk {
    volume_id = libvirt_volume.bongus_d1.id
    scsi = true
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
