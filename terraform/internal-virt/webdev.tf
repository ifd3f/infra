resource "lxd_profile" "webdev" {
  name = "webdev"

  config = {
    "security.nesting"     = true
    "cloud-init.user-data" = file("${var.config_dir}/webdev.yml")
  }
}

resource "lxd_container" "webdev" {
  name  = "webdev"
  image = "images:fedora/35/cloud"

  profiles = [lxd_profile.webdev.name]

  lifecycle {
    # i don't wanna destroy my code
    # prevent_destroy = true
  }

  limits = {
    cpu    = 16
    memory = "32GB"
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent  = var.exposed_bridge
    }
  }

  device {
    name = "rootvol"
    type = "disk"
    properties = {
      path = "/"
      size = "85GB"
      pool = lxd_storage_pool.dpool.id
    }
  }
}

