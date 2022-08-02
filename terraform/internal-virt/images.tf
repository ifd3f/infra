resource "libvirt_volume" "centos8_base" {
  name   = "centos8.qcow2"
  source = var.centos8_image
  format = "qcow2"
}

