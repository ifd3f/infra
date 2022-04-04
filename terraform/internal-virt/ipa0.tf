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
      "ipv4.address" = "192.168.1.5/64"
      "ipv6.address" = "fd53:1de8:470a:501::dead:beef/64"
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

