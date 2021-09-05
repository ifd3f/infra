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

// Apex points to Vercel: https://vercel.com/docs/custom-domains#apex-domains
resource "cloudflare_record" "personal_site_apex" {
  zone_id = cloudflare_zone.primary.id
  name    = "@"
  value   = "76.76.21.21"
  type    = "A"
  proxied = false
}

// API points to Oracle Cloud
resource "cloudflare_record" "personal_site_api" {
  name    = "api"
  proxied = false
  type    = "CNAME"
  value   = "oci.h.astrid.tech"
  zone_id = cloudflare_zone.primary.id
}
