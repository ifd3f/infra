// I'm currently sitting on astridyu.com.
resource "cloudflare_record" "name_site_redirect" {
  name    = "@"
  proxied = true
  type    = "A"
  value   = "69.69.69.69"
  zone_id = cloudflare_zone.name.id
}

// It should redirect to astrid.tech.
resource "cloudflare_page_rule" "name_redirects_to_primary" {
  priority = 1
  status   = "active"
  target   = "*astridyu.com/*"
  zone_id  = cloudflare_zone.name.id
  actions {
    forwarding_url {
      status_code = 302 # Non-permanent, as I may want to change it at some point
      url         = "https://astrid.tech/$2"
    }
  }
}
