resource "cloudflare_record" "oci_public_ip" {
  name    = "oci.h"
  proxied = false
  type    = "A"
  value   = "150.230.37.175"
  zone_id = cloudflare_zone.primary.id
}
