resource "cloudflare_record" "personal_site_release" {
  for_each = toset(["staging", "beta"])

  zone_id = cloudflare_zone.primary.id
  name    = each.key
  value   = "cname.vercel-dns.com"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "personal_site_www" {
  name    = "www"
  proxied = false
  type    = "CNAME"
  value   = "astrid.tech"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "personal_site_apex" {
  zone_id = cloudflare_zone.primary.id
  name    = "@"
  value   = "76.76.21.21"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "personal_site_api" {
  name    = "api"
  proxied = false
  type    = "A"
  value   = "152.67.235.7"
  zone_id = cloudflare_zone.primary.id
}
