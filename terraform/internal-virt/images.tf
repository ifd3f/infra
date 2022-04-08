resource "libvirt_volume" "centos8_base" {
  name = "centos8.qcow2"
  source = "${var.libvirt_images_dir}/centos-8.qcow2"
  format = "qcow2"
}

