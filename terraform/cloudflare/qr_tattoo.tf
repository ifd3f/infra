// QR code controller domain, at qr.arm.astridyu.com.
resource "cloudflare_record" "qr_tattoo_controller" {
  zone_id = cloudflare_zone.name.id
  name    = "qr.arm"
  value   = "oci.h.astrid.tech"
  type    = "CNAME"
  proxied = false
}

// The tattoo domain is the QR code that will be tattooed on my arm.
resource "cloudflare_record" "qr_tattoo" {
  zone_id = cloudflare_zone.tattoo.id
  name    = "@"
  value   = "69.69.69.69"
  type    = "A"
  proxied = true
}

// Redirect to QR code controller.
resource "cloudflare_page_rule" "temp_tattoo_redirects_to_qr" {
  priority = 1
  status   = "active"
  target   = "*${cloudflare_zone.tattoo.zone}/*"
  zone_id  = cloudflare_zone.tattoo.id
  actions {
    forwarding_url {
      status_code = 301 # Permanent, as this is the domain's sole purpose.
      url         = "https://qr.arm.astridyu.com/$2"
    }
  }
}

// q.aay.tw is the domain I minted on my temporary tattoos.
resource "cloudflare_record" "qr_temporary" {
  zone_id = cloudflare_zone.short.id
  name    = "q"
  value   = "69.69.69.69"
  type    = "A"
  proxied = true
}

// Redirect q.aay.tw to QR code controller.
resource "cloudflare_page_rule" "perm_tattoo_redirects_to_qr" {
  priority = 1
  status   = "active"
  target   = "*q.aay.tw/*"
  zone_id  = cloudflare_zone.short.id
  actions {
    forwarding_url {
      status_code = 302 # Non-permanent, as q.aay.tw will be deallocated soon
      url         = "https://qr.arm.astridyu.com/$2"
    }
  }
}
