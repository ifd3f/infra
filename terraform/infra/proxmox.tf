variable "pm_url_root" {
  description = "Proxmox server API root."
  type = string
}

variable "pm_user" {
  description = "Proxmox user."
  type = string
}

variable "pm_pass" {
  description = "Proxmox user's password."
  type = string
  sensitive = true
}

variable "ssh_pubkey" {
  description = "Public key to user for LXC containers."
  type = string
  sensitive = true
}

provider "proxmox" {
  pm_api_url = var.pm_url_root
  pm_user = var.pm_user
  pm_password = var.pm_pass
  pm_tls_insecure = true
}