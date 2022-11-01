resource "cloudflare_record" "oci_public_ip" {
  name    = "oci.h"
  proxied = false
  type    = "A"
  value   = "152.67.253.45"
  zone_id = cloudflare_zone.primary.id
}

resource "cloudflare_record" "diluc_public_ip" {
  name    = "diluc.h"
  proxied = false
  type    = "A"
  value   = local.diluc_ip
  zone_id = cloudflare_zone.primary.id
}
