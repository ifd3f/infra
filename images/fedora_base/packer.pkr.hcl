variable "output_image_name" {
  type = string 
  default = "fedora_base"
}

source "lxd" "fedorabase" {
  image = "images:fedora/34/amd64"
  output_image = var.output_image_name
  
  publish_properties = {
    description = "Fedora LXC base image for cool pet services"
  }
}

build {
  sources = ["source.lxd.fedorabase"]

  provisioner "file" {
    source = "${path.root}/passwordless-sudo"
    destination = "/tmp/passwordless-sudo"
  }

  provisioner "file" {
    source = "${path.root}/sshd_config"
    destination = "/tmp/sshd_config"
  }

  provisioner "shell" {
    script = "${path.root}/provision.sh"
  }
}