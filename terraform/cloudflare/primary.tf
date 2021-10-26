resource "cloudflare_record" "internal_services" {
  count = 1
  
  zone_id = cloudflare_zone.primary.id
  name    = "s"
  value   = "ipa${count.index}.id.astrid.tech"
  type    = "NS"
  proxied = false
}

resource "cloudflare_record" "identity_zone" {
  count = 1

  zone_id = cloudflare_zone.primary.id
  name    = "id"
  value   = "ipa${count.index}.id.astrid.tech"
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

resource "cloudflare_record" "cloud_wiki" {
  name    = "cloud"
  proxied = false
  type    = "CNAME"
  value   = "astralbijection.github.io"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "personal_wiki" {
  name    = "wiki"
  proxied = false
  type    = "CNAME"
  value   = "astralbijection.github.io"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "primary_google_site_verification" {
  name    = "astrid.tech"
  proxied = false
  type    = "TXT"
  value   = "google-site-verification=eeNf9_2KGQ2L9H5zImRlebdGTnR-_t0qBNlnZrHk53Q"
  zone_id = cloudflare_zone.primary.id
}
