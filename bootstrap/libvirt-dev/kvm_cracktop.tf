# cracktop installer
resource "libvirt_volume" "cracktop_install" {
  name   = "bootstrap-dev-cracktop-install.iso"
  source = "images/debian.iso"
}

# cracktop boot disk
resource "libvirt_volume" "cracktop_boot" {
  name = "bootstrap-dev-cracktop-boot.qcow2"
  size = 6000
}

# Cracktop, as a secondary Proxmox node
resource "libvirt_domain" "cracktop" {
  name        = "bootstrap-dev-cracktop"
  description = "Cracktop analogue"
  memory      = 4000
  vcpu        = 2
  autostart   = false

  network_interface {
    network_name = libvirt_network.inner.name
  }

  disk {
    volume_id = libvirt_volume.debian.id
  }

  disk {
    volume_id = libvirt_volume.cracktop_boot.id
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
