/*
resource "libvirt_volume" "ipa0_root" {
  name = "ipa0.qcow2"
  base_volume_id = libvirt_volume.centos8_base.id
}

resource "libvirt_cloudinit_disk" "ipa0_init" {
  name = "ipa0-init.iso"
  user_data = file("${var.config_dir}/ipa.yml")
  network_config = file("${var.config_dir}/ipa.net.yml")
}

resource "libvirt_domain" "ipa0" {
  name = "ipa0"
  memory = "6144"
  vcpu = 4

  cloudinit = libvirt_cloudinit_disk.ipa0_init.id
  autostart = true

  disk {
    volume_id = libvirt_volume.ipa0_root.id
    scsi = true
  }

  network_interface {
    network_name = var.exposed_bridge
    addresses = ["192.168.1.5"]
  }
}
*/
