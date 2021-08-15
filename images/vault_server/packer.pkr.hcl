variable "base_image_name" {
  type = string 
  default = "local:fedora_base"
}

source "lxd" "ops" {
  image = var.base_image_name
  output_image = "vault_server"
  
  publish_properties = {
    description = "Vault Server"
  }
}

build {
  sources = ["source.lxd.ops"]

  provisioner "file" {
    source = "${path.root}/provision.sh"
    destination = "/tmp/provision.sh"
  }

  provisioner "file" {
    source = "${path.root}/config.hcl"
    destination = "/tmp/config.hcl"
  }

  provisioner "file" {
    source = "${path.root}/vault.service"
    destination = "/tmp/vault.service"
  }

  provisioner "shell" {
    inline = [
      "bash /tmp/provision.sh"
    ]
  }
}
