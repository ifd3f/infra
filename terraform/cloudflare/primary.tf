resource "cloudflare_record" "ipa_domain" {
  zone_id = cloudflare_zone.primary.id
  name    = "id"
  value   = "ipa0.h.astrid.tech"
  type    = "NS"
  proxied = false
}

resource "cloudflare_record" "ipa_host" {
  zone_id = cloudflare_zone.primary.id
  name    = "ipa0.h"
  value   = "2a02:c207:2087:999:1::2"
  type    = "AAAA"
  proxied = false
}

resource "cloudflare_record" "cloud_wiki" {
  name    = "cloud"
  proxied = false
  type    = "CNAME"
  value   = "ifd3f.github.io"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "personal_wiki" {
  name    = "wiki"
  proxied = false
  type    = "CNAME"
  value   = "ifd3f.github.io"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "grafana" {
  name    = "grafana"
  proxied = false
  type    = "A"
  value   = local.diluc_ip
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "primary_google_site_verification" {
  name    = "astrid.tech"
  proxied = false
  type    = "TXT"
  value   = "google-site-verification=eeNf9_2KGQ2L9H5zImRlebdGTnR-_t0qBNlnZrHk53Q"
  zone_id = cloudflare_zone.primary.id
}

// Alias to Backblaze storage.
resource "cloudflare_record" "backblaze_alias" {
  zone_id = cloudflare_zone.primary.id
  type    = "CNAME"
  name    = "media"
  value   = "f000.backblazeb2.com"
  proxied = false
}

resource "cloudflare_record" "sso" {
  name    = "sso"
  proxied = false
  type    = "CNAME"
  value   = "diluc.h.astrid.tech"
  zone_id = cloudflare_zone.primary.id
}