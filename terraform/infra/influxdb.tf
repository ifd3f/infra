resource "random_password" "leibniz_password" {
  length = 24
  special = false
}

resource "proxmox_lxc" "srv_leibniz" {
  target_node = "badtop"
  hostname = "leibniz.cloud.astrid.tech"
  ostemplate = "ProxmoxResources:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  password = random_password.leibniz_password.result
  unprivileged = true
  start = true
  ssh_public_keys = var.ssh_pubkey

  rootfs {
    storage = "local-lvm"
    size = "128G"
  }

  network {
    name = "eth0"
    bridge = "vmbr0"
    ip = "dhcp"
  }
}

resource "local_file" "leibniz_password" {
  content = random_password.leibniz_password.result
  filename = "${path.module}/credentials/leibniz.txt"
}