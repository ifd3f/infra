source "lxd" "ops" {
  image = "local:fedora_base"
  output_image = "hashicorp_vault"
  
  publish_properties = {
    description = "FreeIPA Server"
  }
}

build {
  sources = ["source.lxd.ops"]

  provisioner "file" {
    source = "${path.root}/auto-install-ipa.sh"
    destination = "/tmp/auto-install-ipa.sh"
  }

  provisioner "shell" {
    script = "${path.root}/provision.sh"
  }
}
