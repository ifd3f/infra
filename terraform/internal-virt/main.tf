terraform {
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "~> 1.7.1"
    }
  }
}

provider "lxd" {
  accept_remote_certificate = true
  generate_client_certificates = true
}

