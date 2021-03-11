terraform {
  required_version = ">= 0.13.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    proxmox = {
      source = "Telmate/proxmox"
      version = ">= 2.6.7"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.pm_url_root
  pm_user = var.pm_user
  pm_password = var.pm_pass
  pm_tls_insecure = true
}


locals {
  targets = {
    cracktop = {
      index = 0
      mem = 7168
      swap = 4096
      cores = 4
      storage = "64G"
    }
    thonkpad = {
      index = 1
      mem = 7168
      swap = 4096
      cores = 4
      storage = "64G"
    }
    badtop = {
      index = 2
      mem = 3072
      swap = 4096
      cores = 4
      storage = "64G"
    }
  }
}

resource "random_password" "server_password" {
  for_each = local.targets

  length = 24
  special = false
}

resource "local_file" "server_password" {
  for_each = local.targets

  content = random_password.server_password[each.key].result
  filename = "${path.module}/credentials/server_${each.key}.txt"
}

resource "proxmox_vm_qemu" "kubernetes" {
  for_each = local.targets

  name = "${each.key}-kube.lan"
  target_node = each.key
  vmid = 200 + each.value.index
  description = "K3S"

  preprovision = true
  os_type = "ubuntu"
  ssh_forward_ip = "10.0.0.1"
  start = true
  onboot = true

  pool = "kubernetes"
  memory = each.value.mem
  swap = each.value.swap
  cores = each.value.cores

  ostemplate = "sambruh:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  password = random_password.server_password[each.key].result
  ssh_public_keys = var.ssh_pubkey

  unprivileged = false
  features {
    nesting = true
    fuse = true
    mount = "nfs;cifs"
  }

  rootfs {
    storage = "local-lvm"
    size = "8G"
  }

  network {
    name = "eth0"
    bridge = "vmbr0"
    ip = "192.168.8.${each.value.index + 40}/24"
    gw = "192.168.8.1"
  }
}
