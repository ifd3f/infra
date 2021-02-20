terraform {
  required_version = ">= 0.13.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    proxmox = {
      source = "Telmate/proxmox"
      version = ">= 2.6"
    }
  }
}
