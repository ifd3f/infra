
# Bongus boot disk
resource "libvirt_volume" "bongus_boot" {
  name = "bootstrap-dev-bongus.qcow2"
  source = local.proxmox_seed_image
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
    volume_id = libvirt_volume.bongus_boot.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
