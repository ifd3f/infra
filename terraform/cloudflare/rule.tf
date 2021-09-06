resource "cloudflare_page_rule" "short_always_http" {
  priority = 1
  status = "active"
  target = "http://*aay.tw/*"
  zone_id = cloudflare_zone.short.id
  actions {
    always_use_https = true
  }
}

resource "cloudflare_page_rule" "name_redirects_to_primary" {
  priority = 1
  status = "active"
  target = "*astridyu.com/*"
  zone_id = cloudflare_zone.name.id
  actions {
    forwarding_url {
      status_code = 302  # Non-permanent, as I may want to change it at some point
      url = "https://astrid.tech/$2"
    }
  }
}

