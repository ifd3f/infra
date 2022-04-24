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

resource "cloudflare_record" "aliaconda" {
  name    = "aliaconda.of"
  proxied = false
  type    = "AAAA"
  value   = "fd53:1de8:470a:0011:0000:0000:0000:0027"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "cloud_wiki" {
  name    = "cloud"
  proxied = false
  type    = "CNAME"
  value   = "astridyu.github.io"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "personal_wiki" {
  name    = "wiki"
  proxied = false
  type    = "CNAME"
  value   = "astridyu.github.io"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "primary_google_site_verification" {
  name    = "astrid.tech"
  proxied = false
  type    = "TXT"
  value   = "google-site-verification=eeNf9_2KGQ2L9H5zImRlebdGTnR-_t0qBNlnZrHk53Q"
  zone_id = cloudflare_zone.primary.id
}
