variable "base_image_name" {
  type = string 
  default = "local:fedora_base"
}

variable "admin_password" {
  type = string 
}

variable "ds_password" {
  type = string 
}

variable "dns0" {
  type = string 
  default = "8.8.8.8"
}

variable "dns1" {
  type = string 
  default = "8.8.4.4"
}

source "lxd" "initialmaster" {
  image = var.base_image_name
  output_image = "freeipa-server-initial"
  
  publish_properties = {
    description = "Initial FreeIPA Master"
  }
}

source "lxd" "replica" {
  image = var.base_image_name
  output_image = "freeipa_server_replica"
  
  publish_properties = {
    description = "FreeIPA Replica"
  }
}

build {
  sources = ["source.lxd.initialmaster", "source.lxd.replica"]

  provisioner "shell" {
    script = "${path.root}/install-packages.sh"
  }

  provisioner "shell" {
    only = ["source.lxd.initialmaster"]
    script = "${path.root}/install-freeipa-master.sh"
    environment_vars = [
      "dns0=${var.dns0}",
      "dns1=${var.dns1}",
      "DS_PASSWORD=${var.ds_password}",
      "ADMIN_PASSWORD=${var.admin_password}",
    ]
  }
}
