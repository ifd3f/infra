resource "cloudflare_page_rule" "short_always_http" {
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

resource "cloudflare_page_rule" "name_always_http" {
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

