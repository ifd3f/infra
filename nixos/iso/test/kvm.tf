resource "libvirt_volume" "installer" {
  name = "nixos_test_nixos.iso"
  source = var.nixos_iso
}

resource "libvirt_volume" "root_disk" {
  name = "nixos_test_root.qcow2"
  size = 20 * 1024 * 1024 * 1024  # 20GiB
}

resource "libvirt_domain" "nixos_test" {
  name        = "nixosTest"
  description = "Nixos test"
  memory      = 4000
  vcpu        = 2
  autostart   = false

  network_interface {
    network_name = libvirt_network.net.name
  }

  disk {
    volume_id = libvirt_volume.installer.id
  }

  disk {
    volume_id = libvirt_volume.root_disk.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  xml {
    xslt = file("modify.xslt")
  }
}
