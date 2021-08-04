resource "cloudflare_record" "name_site_redirect" {
  name    = "astridyu.com"
  proxied = true
  type    = "CNAME"
  value   = "astrid.tech"
  zone_id = cloudflare_zone.name.id
}

