resource "cloudflare_record" "primary_ns" {
  for_each = {
    "s"  = "ipa0.id.astrid.tech" # Internal services
    "id" = "ipa0.id.astrid.tech" # Identity zone
  }

  zone_id = cloudflare_zone.primary.id
  name    = each.key
  value   = each.value
  type    = "NS"
  proxied = false
}

resource "cloudflare_record" "dnd_wiki" {
  name    = "wiki.dnd"
  proxied = false
  type    = "A"
  value   = "152.67.235.7"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "primary_google_site_verification" {
  name    = "astrid.tech"
  proxied = false
  type    = "TXT"
  value   = "google-site-verification=eeNf9_2KGQ2L9H5zImRlebdGTnR-_t0qBNlnZrHk53Q"
  zone_id = cloudflare_zone.primary.id
}
