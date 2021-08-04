resource "cloudflare_record" "terraform_managed_resource_1510f596f002779c695f82c7fe8090d7" {
  name = "astridyu.com"
  proxied = true
  ttl = 1
  type = "CNAME"
  value = "astrid.tech"
  zone_id = "e3c1d610b58b03504d7325839426de09"
}

