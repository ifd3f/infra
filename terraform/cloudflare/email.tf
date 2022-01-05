// Email configuration info. 
// For more information, see:
// - https://www.namecheap.com/support/knowledgebase/article.aspx/1340/2176/namecheap-private-email-records-for-domains-with-thirdparty-dns/
// - https://www.namecheap.com/support/knowledgebase/article.aspx/9967/31/how-to-set-up-dns-records-for-namecheap-email-service-with-cloudflare-cpanel-and-private-email/#pe

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
  for_each = {
    "mx1.privateemail.com" = 10
    "mx2.privateemail.com" = 20
  }
  name     = "astrid.tech"
  priority = each.value
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
  type    = "SRV"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "primary_spf" {
  name    = "@"
  type    = "TXT"
  value   = "v=spf1 include:spf.privateemail.com ~all"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "primary_dmarc" {
  name    = "_dmarc"
  type    = "TXT"
  value   = "v=DMARC1; p=none; rua=mailto:astrid@astrid.tech; ruf=mailto:astrid@astrid.tech; sp=reject; ri=86400"
  zone_id = cloudflare_zone.primary.id
}

locals {
  // Domains that do not have email.
  no_email = toset([
    cloudflare_zone.name.id,
    cloudflare_zone.short.id,
    cloudflare_zone.s3e.id,
    cloudflare_zone.tattoo.id,
  ])
}

resource "cloudflare_record" "drop_spoofed_records_spf" {
  for_each = local.no_email

  zone_id = each.key
  type    = "TXT"
  name    = "@"
  value   = "v=spf1 -all"
  proxied = false
}

resource "cloudflare_record" "drop_spoofed_records_dkim" {
  for_each = local.no_email

  zone_id = each.key
  type    = "TXT"
  name    = "*._domainkey"
  value   = "v=DKIM1; p="
  proxied = false
}

resource "cloudflare_record" "drop_spoofed_records_dmarc" {
  for_each = local.no_email

  zone_id = each.key
  type    = "TXT"
  name    = "_dmarc"
  value   = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s; rua=mailto:astrid@astrid.tech"
  proxied = false
}