variable output_image_name {
  type = string 
  default = "lab_maas"
}

source lxd labmaas {
  image = "images:ubuntu/hirsute/amd64"
  output_image = var.output_image_name
  
  publish_properties = {
    description = "MaaS server"
  }
}

build {
  sources = ["source.lxd.labmaas"]

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
