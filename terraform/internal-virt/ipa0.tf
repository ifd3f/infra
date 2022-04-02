resource "lxd_container" "ipa0" {
  name = "ipa0"
  image = "images:fedora/35/cloud"
  type = "virtual-machine"
  config = yamldecode(file("${var.config_dir}/ipa.yml"))

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
      pool = lxd_storage_pool.dpool.id
    }
  }
}

