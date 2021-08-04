resource "cloudflare_record" "terraform_managed_resource_af47bbbf3ff2177f90c2cc3b88be44d9" {
  name = "api"
  proxied = false
  ttl = 1
  type = "A"
  value = "152.67.235.7"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_2c92865f12e6cfc7920e587cbb17ab7c" {
  name = "astrid.tech"
  proxied = false
  ttl = 1
  type = "A"
  value = "76.76.21.21"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_d9481ccca85deb98bd29df1cf6e4bbfa" {
  name = "wiki.dnd"
  proxied = false
  ttl = 1
  type = "A"
  value = "152.67.235.7"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_96426a32e472d6ccce8cae0224eeba1d" {
  name = "autoconfig"
  proxied = false
  ttl = 1
  type = "CNAME"
  value = "privateemail.com"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_35d43f3a0e35681b69b08623ae6f6c90" {
  name = "autodiscover"
  proxied = false
  ttl = 1
  type = "CNAME"
  value = "privateemail.com"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_912a428844e16112c76a371850827181" {
  name = "beta"
  proxied = false
  ttl = 1
  type = "CNAME"
  value = "cname.vercel-dns.com"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_924cb089d1b984589a013f9fef861d34" {
  name = "mail"
  proxied = false
  ttl = 1
  type = "CNAME"
  value = "privateemail.com"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_478266826189a884b1f92b1d733b8792" {
  name = "notes"
  proxied = false
  ttl = 1
  type = "CNAME"
  value = "oci1.h.astrid.tech"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_79f1be1a3e9cf8372deb93e5594ff951" {
  name = "staging"
  proxied = false
  ttl = 1
  type = "CNAME"
  value = "cname.vercel-dns.com"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_354a765856ec5cc2dac91961c9e6a0db" {
  name = "www"
  proxied = false
  ttl = 1
  type = "CNAME"
  value = "astralbijection.github.io"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_de1fc4bad61bc540b5060716fceff5bf" {
  name = "astrid.tech"
  priority = 10
  proxied = false
  ttl = 1
  type = "MX"
  value = "mx2.privateemail.com"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_2109f2d11adedde1e5388b72e9cbc579" {
  name = "astrid.tech"
  priority = 10
  proxied = false
  ttl = 1
  type = "MX"
  value = "mx1.privateemail.com"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_cce10585be52c0167a0757693400be4d" {
  name = "id"
  proxied = false
  ttl = 1
  type = "NS"
  value = "ipa0.id.astrid.tech"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_6269bdd5d469662085710a2cf6195e48" {
  name = "p"
  proxied = false
  ttl = 1
  type = "NS"
  value = "ipa0.p.astrid.tech"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_bc4d1aefea1736736aa72e1ef9ca4a83" {
  name = "s"
  proxied = false
  ttl = 1
  type = "NS"
  value = "ipa0.id.astrid.tech"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_7f25b530e59faccd9f5131af722bb343" {
  name = "s"
  proxied = false
  ttl = 1
  type = "NS"
  value = "ipa0.p.astrid.tech"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_89065f8acc60af682a9aa123c8f92cdb" {
  data = {
    name = "astrid.tech"
    port = 443
    priority = 0
    proto = "_tcp"
    service = "_autodiscover"
    target = "privateemail.com"
    weight = 0
  }
  name = "_autodiscover._tcp"
  priority = 0
  proxied = false
  ttl = 1
  type = "SRV"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_d3c4a8342a4d16176990adcc3e8354d8" {
  name = "astrid.tech"
  proxied = false
  ttl = 1
  type = "TXT"
  value = "google-site-verification=eeNf9_2KGQ2L9H5zImRlebdGTnR-_t0qBNlnZrHk53Q"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_329006505b9baaebd01582d5aae0d6f2" {
  name = "astrid.tech"
  proxied = false
  ttl = 1
  type = "TXT"
  value = "v=spf1 include:spf.privateemail.com ~all"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

resource "cloudflare_record" "terraform_managed_resource_5f03d5f9845e5a8c9b92e51c19b76d78" {
  name = "matrix"
  proxied = false
  ttl = 1
  type = "TXT"
  value = "\"heritage=external-dns,external-dns/owner=default,external-dns/resource=ingress/matrix/synapse-ingress\""
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
}

