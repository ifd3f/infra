variable "config_dir" {
  description = "Configs directory"
  type = string
  default = "./configs"
}

variable "exposed_bridge" {
  description = "The bridge that is exposed to the HV's LAN"
  type = string
  default = "br0"
}

