source "lxd" "ops" {
  image = "local:fedora_base"
  output_image = "hashicorp_vault"
  
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
