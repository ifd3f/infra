# Bongus installer
resource "libvirt_volume" "bongus_install" {
  name   = "bootstrap-dev-bongus-install.iso"
  source = "images/debian.iso"
}

# Bongus boot disk
resource "libvirt_volume" "bongus_boot" {
  name = "bootstrap-dev-bongus-boot.qcow2"
  size = 32000
}

# Bongus, our big cool server machine
resource "libvirt_domain" "bongus" {
  name        = "bootstrap-dev-bongus"
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
    volume_id = libvirt_volume.bongus_install.id
  }

  disk {
    volume_id = libvirt_volume.bongus_boot.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
