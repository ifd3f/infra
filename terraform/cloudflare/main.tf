terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
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

resource "cloudflare_record" "cloud_wiki" {
  zone_id = cloudflare_zone.primary.id
  name    = "cloud"
  value   = "cloud-astrid-tech.github.io"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "short_qr" {
  zone_id = cloudflare_zone.short.id
  name    = "q"
  value   = "astrid.tech"
  type    = "CNAME"
  proxied = true
}