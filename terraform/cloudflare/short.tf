resource "cloudflare_record" "terraform_managed_resource_28e0342a8d5ebb349cfd74dd88c23c35" {
  name = "aay.tw"
  proxied = false
  ttl = 1
  type = "A"
  value = "152.67.235.7"
  zone_id = "bd88692b8c1560d17ffed76e32270762"
}

resource "cloudflare_record" "terraform_managed_resource_4a4b310c448c779580dff518313308d2" {
  name = "q"
  proxied = true
  ttl = 1
  type = "CNAME"
  value = "astrid.tech"
  zone_id = "bd88692b8c1560d17ffed76e32270762"
}

