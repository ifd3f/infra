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
    cracktop = 0
    //thonkpad = 1
  }
}

resource "random_password" "ipa_password" {
  for_each = local.targets

  length = 24
  special = false
}

resource "local_file" "ipa_password" {
  for_each = local.targets

  content = random_password.ipa_password[each.key].result
  filename = "${path.module}/credentials/ipa_${each.key}.txt"
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

resource "proxmox_vm_qemu" "ipa" {
  for_each = local.targets

  target_node = each.key
  vmid = 500 + each.value
  hostname = "ipa${each.value}.p.astrid.tech"
  desc = "FreeIPA server"

  start = false
  onboot = true

  pool = "ipa"
  memory = 1536
  swap = 256
  cores = 2

  ostemplate = "sambruh:vztmpl/fedora-33-default_20201115_amd64.tar.xz"
  password = random_password.server_password[each.key].result
  ssh_public_keys = var.ssh_pubkey

  features {
    nesting = true
  }

  rootfs {
    storage = "local-lvm"
    size = "8G"
  }

  network {
    name = "eth0"
    bridge = "vmbr0"
    ip = "192.168.8.9/24"
    gw = "192.168.8.1"
  }
}
