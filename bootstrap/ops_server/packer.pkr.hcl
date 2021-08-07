source "lxd" "ops" {
  image = "images:fedora/34/amd64"
  output_image = "ops_server"
  
  publish_properties = {
    description = "Deployment Operations Server"
  }
}

build {
  sources = ["source.lxd.ops"]

  # because ansible provisioner didn't want to work with me T_T
  #  provisioner "shell" {
  #    inline = [
  #      "dnf install -y dnf-plugins-core",
  #      "dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo",
  #      "echo '${file("kubernetes.repo")}' > /etc/yum.repos.d/kubernetes.repo",
  #
  #      "dnf install -y git gettext terraform ansible kubectl",
  #      "useradd -m -c Operator operator",
  #      "mkdir /infra",
  #      "chmod 644 /infra",
  #      "chown operator:operator /infra",
  #      "su operator",
  #      "git clone https://github.com/astralbijection/infrastructure.git /infra",
  #    ]
  #  }

  provisioner "shell" {
    inline = [
      "dnf install -y openssh-server",
      "systemctl start sshd",
    ]
  }

  provisioner "ansible" {
    playbook_file = "./setup_ops_local.yaml"
    galaxy_file = "./requirements.yml"
    extra_arguments = ["-vv"]
  }
}
