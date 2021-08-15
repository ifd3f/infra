variable "ansible_ssh_key_path" {
  type = string 
}

source "lxd" "fedorabase" {
  image = "images:fedora/34/amd64"
  output_image = "fedora_base"
  
  publish_properties = {
    description = "Preconfigured Ansible-ready Fedora base image"
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
    source = "${path.root}/provision.sh"
    destination = "/tmp/provision.sh"
  }

  provisioner "file" {
    source = var.ansible_ssh_key_path
    destination = "/tmp/ansible_ssh.pub"
  }

  provisioner "shell" {
    inline = ["bash /tmp/provision.sh"]
  }

  // provisioner "ansible" {
  //   playbook_file = "${path.root}/test_playbook.yml"
  //   user = "ansible"
  //   use_proxy = false
  // }
}
