resource "cloudflare_record" "personal_site_release" {
  for_each = toset(["staging", "beta"])

  zone_id = cloudflare_zone.primary.id
  type    = "CNAME"
  name    = each.key
  value   = "cname.vercel-dns.com"
  proxied = false
}

resource "cloudflare_record" "personal_site_www" {
  zone_id = cloudflare_zone.primary.id
  type    = "CNAME"
  name    = "www"
  value   = "astrid.tech"
  proxied = false
}

// Apex points to Vercel: https://vercel.com/docs/custom-domains#apex-domains
resource "cloudflare_record" "personal_site_apex" {
  zone_id = cloudflare_zone.primary.id
  type    = "A"
  name    = "@"
  value   = "76.76.21.21"
  proxied = false
}

// API points to Oracle Cloud, which hosts the backend
resource "cloudflare_record" "personal_site_api" {
  zone_id = cloudflare_zone.primary.id
  type    = "CNAME"
  name    = "api"
  value   = "oci.h.astrid.tech"
  proxied = false // Do not proxy, or else ACME won't work
}

// Short apex points to Oracle Cloud, which hosts the backend
resource "cloudflare_record" "personal_site_shortener" {
  zone_id = cloudflare_zone.short.id
  type    = "A"
  name    = "@"
  value   = cloudflare_record.oci_public_ip.value
  proxied = false // Do not proxy, or else ACME won't work
}
