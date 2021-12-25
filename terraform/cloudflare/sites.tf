resource "cloudflare_record" "site_0" {
  name    = "s00"
  proxied = false
  type    = "A"
  value   = "24.23.210.97"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "site_1" {
  name    = "s01"
  proxied = false
  type    = "A"
  value   = "71.84.29.98"
  zone_id = cloudflare_zone.primary.id
}
