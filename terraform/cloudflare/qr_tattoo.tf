// This is the QR code that will be tattooed on my arm.  Specifically, 
// the encoded value is IQ.S3e.Top
// TODO: confirm an actual code with the tattoo artist
resource "cloudflare_record" "qr_tattoo" {
  zone_id = cloudflare_zone.s3e.id
  name    = "iq"
  value   = "oci.h.astrid.tech"
  type    = "CNAME"
  proxied = true
}

// Because that domain is a pain to type on a phone, the admin page
// can exist on an easier-to-type domain.
resource "cloudflare_record" "qr_admin" {
  zone_id = cloudflare_zone.short.id
  name    = "qr"
  value   = "oci.h.astrid.tech"
  type    = "CNAME"
  proxied = true
}

// This is the domain I minted on my temporary tattoos.
resource "cloudflare_record" "qr_admin" {
  zone_id = cloudflare_zone.short.id
  name    = "q"
  value   = "oci.h.astrid.tech"
  type    = "CNAME"
  proxied = true
}
