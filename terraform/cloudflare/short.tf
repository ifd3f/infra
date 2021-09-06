resource "cloudflare_record" "short_qr" {
  zone_id = cloudflare_zone.short.id
  name    = "q"
  value   = "astrid.tech"
  type    = "CNAME"
  proxied = true
}
