resource "lxd_profile" "fhsdev" {
  name = "fhsdev"

  config = {
    "cloud-init.user-data" = file("${var.config_dir}/fhsdev.yml")
  }
}

resource "lxd_container" "fhsdev" {
  name = "fhsdev"
  image = "images:fedora/35/cloud"
  type = "virtual-machine"

  profiles = [ lxd_profile.fhsdev.name ]

  lifecycle {
    # i don't wanna destroy my code
    prevent_destroy = true
  }

  limits = {
    cpu = 16
    memory = "32GB"
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent = var.exposed_bridge
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

