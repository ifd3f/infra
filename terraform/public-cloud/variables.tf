variable "b2_app_key" {
  description = "Backblaze app key"
  type        = string
}

variable "b2_app_key_id" {
  description = "Backblaze app key ID"
  type        = string
}

variable "cloudflare_email" {
  description = "Cloudflare email"
  type        = string
}

variable "cloudflare_api_key" {
  description = "Cloudflare API key"
  type        = string
}

variable "ssh_private_key" {
  description = "SSH private key for uploading files"
  type        = string
}
