variable "base_image_name" {
  type = string 
  default = "local:fedora_base"
}

source "lxd" "ops" {
  image = var.base_image_name
  output_image = "ops_server"
  
  publish_properties = {
    description = "Deployment Operations Server"
  }
}

build {
  sources = ["source.lxd.ops"]

  provisioner "file" {
    source = "${path.root}/provision.sh"
    destination = "/tmp/provision.sh"
  }

  provisioner "shell" {
    inline = [
      "bash /tmp/provision.sh"
    ]
  }
}
