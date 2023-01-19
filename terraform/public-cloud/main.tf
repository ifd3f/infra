terraform {
  required_version = ">= 1.0.0"

  backend "remote" {
    organization = "astralbijection"

    workspaces {
      name = "public-cloud"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
    b2 = {
      source = "Backblaze/b2"
    }
    remote = {
      source = "tenstad/remote"
    }
  }
}

provider "b2" {
  application_key    = var.b2_app_key
  application_key_id = var.b2_app_key_id
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

locals {
  diluc_ip = "173.212.242.107"
}

// TODO remove this one
provider "remote" {
  alias = "contabo"

  max_sessions = 2

  conn {
    host        = local.diluc_ip
    user        = "terraform"
    sudo        = true
    private_key = var.ssh_private_key
  }
}

provider "remote" {
  alias = "diluc"

  max_sessions = 2

  conn {
    host        = local.diluc_ip
    user        = "terraform"
    sudo        = true
    private_key = var.ssh_private_key
  }
}

provider "remote" {
  alias = "durin"

  max_sessions = 2

  conn {
    host        = "durin.h.astrid.tech"
    user        = "terraform"
    sudo        = true
    private_key = var.ssh_private_key
  }
}

