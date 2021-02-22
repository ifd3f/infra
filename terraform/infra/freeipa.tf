resource "random_password" "ipa1_password" {
  length = 24
  special = false
}

resource "proxmox_lxc" "srv_ipa1" {
  target_node = "cracktop"
  hostname = "ipa1.cloud.astrid.tech"
  description = "FreeIPA server"

  vmid = 501

  pool = "FreeIPA"
  memory = 1024
  swap = 512
  cores = 2

  ostemplate = "ProxmoxResources:vztmpl/fedora-33-default_20201115_amd64.tar.xz"
  password = random_password.ipa1_password.result
  unprivileged = true
  start = true
  onboot = true
  ssh_public_keys = var.ssh_pubkey

  rootfs {
    storage = "local-lvm"
    size = "8G"
  }

  network {
    name = "eth0"
    bridge = "vmbr0"
    ip = "192.168.1.193/24"
    gw = "192.168.1.254"
  }
}

resource "local_file" "ipa1_password" {
  content = random_password.ipa1_password.result
  filename = "${path.module}/credentials/ipa1.txt"
}