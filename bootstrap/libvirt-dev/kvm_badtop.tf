# ipa0 boot disk
resource "libvirt_volume" "ipa0_boot" {
  name = "bootstrap-dev-ipa0-boot.qcow2"
  size = 32000
}

# Badtop, which will be our domain controller
resource "libvirt_domain" "badtop" {
  name        = "bootstrap-dev-badtop"
  description = "Badtop/ipa0 analogue"
  memory      = 4000
  vcpu        = 2
  autostart   = false

  network_interface {
    network_name = libvirt_network.inner.name
  }

  disk {
    volume_id = libvirt_volume.fedora.id
  }

  disk {
    volume_id = libvirt_volume.ipa0_boot.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  xml {
    xslt = file("boot_order.xslt")
  }
}
