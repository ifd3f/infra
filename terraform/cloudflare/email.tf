
resource "cloudflare_record" "email_autoconfig" {
  name    = "autoconfig"
  proxied = false
  type    = "CNAME"
  value   = "privateemail.com"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "email_autodiscover" {
  name    = "autodiscover"
  proxied = false
  type    = "CNAME"
  value   = "privateemail.com"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "email_mail" {
  name    = "mail"
  proxied = false
  type    = "CNAME"
  value   = "privateemail.com"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "mx_records" {
  for_each = toset(["mx1.privateemail.com", "mx2.privateemail.com"])
  name     = "astrid.tech"
  priority = 10
  proxied  = false
  type     = "MX"
  value    = each.key
  zone_id  = cloudflare_zone.primary.id
}

resource "cloudflare_record" "email_srv" {
  data = {
    name     = "astrid.tech"
    port     = 443
    priority = 0
    proto    = "_tcp"
    service  = "_autodiscover"
    target   = "privateemail.com"
    weight   = 0
  }
  name    = "_autodiscover._tcp"
  proxied = false
  type    = "SRV"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "email_txt" {
  name    = "astrid.tech"
  proxied = false
  type    = "TXT"
  value   = "v=spf1 include:spf.privateemail.com ~all"
  zone_id = cloudflare_zone.primary.id
}
