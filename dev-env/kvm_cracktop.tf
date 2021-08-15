# cracktop installer
resource "libvirt_volume" "cracktop_boot" {
  name   = "bootstrap-dev-cracktop.qcow2"
  source = local.fedora_seed_image
}

# Cracktop, as a secondary Proxmox node
resource "libvirt_domain" "cracktop" {
  name        = "cracktop.hv.astrid.tech"
  description = "Cracktop analogue"
  memory      = 4000
  vcpu        = 2
  autostart   = false

  network_interface {
    network_name = libvirt_network.inner.name
  }

  disk {
    volume_id = libvirt_volume.cracktop_boot.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
