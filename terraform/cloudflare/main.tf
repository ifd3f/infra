terraform {
  required_version = ">= 1.0.0"

  backend "remote" {
    organization = "astralbijection"

    workspaces {
      name = "cloudflare"
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

resource "cloudflare_zone" "primary" {
  // Registrar: https://namecheap.com
  zone = "astrid.tech"
}

resource "cloudflare_zone" "name" {
  // Registrar: https://namecheap.com
  zone = "astridyu.com"
}

resource "cloudflare_zone" "short" {
  // Registrar: https://gandi.net
  zone = "aay.tw"
}

resource "cloudflare_zone" "s3e" {
  // Registrar: https://porkbun.com
  zone = "s3e.top"
}

resource "cloudflare_zone" "tattoo" {
  // Registrar: https://www.cosmotown.com/
  zone = "0q4.org"
}

locals {
  contabo_ip = "173.212.242.107"
}

provider "remote" {
  alias = "contabo"

  max_sessions = 2

  conn {
    host        = local.contabo_ip
    user        = "terraform"
    sudo        = true
    private_key = var.ssh_private_key
  }
}

