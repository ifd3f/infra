# ipa0 boot disk
resource "libvirt_volume" "ipa0_boot" {
  name = "bootstrap-dev-ipa0.qcow2"
  source = local.freeipa_seed_image
}

# Badtop, which will be our domain controller
resource "libvirt_domain" "badtop" {
  name        = "ipa0.id.astrid.tech"
  description = "Badtop/ipa0 analogue"
  memory      = 4000
  vcpu        = 2
  autostart   = false

  network_interface {
    network_name = libvirt_network.inner.name
  }

  disk {
    volume_id = libvirt_volume.ipa0_boot.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
