variable "ansible_ssh_key_path" {
  type = string 
  default = "/root/.ssh/id_rsa.pub"
}

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
    source = "${path.root}/ansible-sudo"
    destination = "/tmp/ansible-sudo"
  }

  provisioner "file" {
    source = "${path.root}/sshd_config"
    destination = "/tmp/sshd_config"
  }

  provisioner "file" {
    source = var.ansible_ssh_key_path
    destination = "/tmp/ansible_ssh.pub"
  }

  provisioner "shell" {
    script = "${path.root}/provision.sh"
  }
}