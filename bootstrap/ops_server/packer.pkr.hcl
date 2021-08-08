source "lxd" "ops" {
  image = "images:fedora/34/amd64"
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
