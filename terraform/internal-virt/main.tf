terraform {
  cloud {
    organization = "astralbijection"

    workspaces {
      name = "infra-internal"
    }
  }

  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "~> 1.7.1"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.6.14"
    }
  }
}

provider "lxd" {
  accept_remote_certificate    = true
  generate_client_certificates = true
}

provider "libvirt" {
  uri = var.libvirt_uri
}

