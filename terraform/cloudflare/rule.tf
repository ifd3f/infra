resource "cloudflare_page_rule" "terraform_managed_resource_51a59d93271dd1863959f9ce14fa1c95" {
  priority = 1
  status = "disabled"
  target = "*aay.tw/*"
  zone_id = "bd88692b8c1560d17ffed76e32270762"
  actions {
    forwarding_url {
      status_code = 302
      url = "https://astrid.tech/$2"
    }
  }
}

resource "cloudflare_page_rule" "terraform_managed_resource_8f613c716963e01273dffa4b5b5e2b37" {
  priority = 1
  status = "active"
  target = "*astrid.tech/*"
  zone_id = "a1c94811845ac7ece3a51cffa2908aac"
  actions {
  }
}

resource "cloudflare_page_rule" "terraform_managed_resource_0578dd3509a6fe1e51e549be687dd286" {
  priority = 1
  status = "active"
  target = "*astridyu.com/*"
  zone_id = "e3c1d610b58b03504d7325839426de09"
  actions {
    forwarding_url {
      status_code = 301
      url = "https://astrid.tech/$2"
    }
  }
}

