terraform {
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
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "cloudflare_zone" "primary" {
  zone = "astrid.tech"
}

resource "cloudflare_zone" "name" {
  zone = "astridyu.com"
}

resource "cloudflare_zone" "short" {
  zone = "aay.tw"
}
