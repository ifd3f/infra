resource "lxd_network" "brdevelop" {
  name = "brdevelop"
}

resource "lxd_container" "gigarouter" {
  name = "gigarouter"
  image = "gigarouter/1/cloud"

  limits = {
    cpu = 4
    memory = "4GB"
  }

  config = {
    #"security.privileged" = true
    #"linux.sysctl.ipv4.conf.all.forwarding" = 1
    #"linux.sysctl.ipv6.conf.all.forwarding" = 1
  }

  device {
    name = "wan"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent = var.exposed_bridge
    }
  }

  device {
    name = "k8slan"
    type = "nic"
    properties = {
      nictype = "ipvlan"
      parent = var.kubecluster_bridge
      mode = "l2"
      "ipv4.address" = "192.168.23.1"
    }
  }

  device {
    name = "devlan"
    type = "nic"
    # TODO ipvlan
    properties = {
      nictype = "bridged"
      parent = lxd_network.brdevelop.name
    }
  }

  device {
    name = "rootvol"
    type = "disk"
    properties = {
      path = "/"
      size = "8GB"
      pool = lxd_storage_pool.dpool.id
    }
  }
}

