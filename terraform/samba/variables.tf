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
