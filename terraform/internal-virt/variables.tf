variable "config_dir" {
  description = "Configs directory"
  type        = string
  default     = "./cloud-init"
}

variable "exposed_bridge" {
  description = "The bridge that is exposed to the HV's LAN"
  type        = string
  default     = "br0"
}

variable "kubecluster_bridge" {
  description = "The bridge for the Kubernetes cluster"
  type        = string
  default     = "brk8s"
}

variable "libvirt_uri" {
  description = "Libvirt socket to connect to"
  type        = string
  default     = "qemu:///system"
}

variable "centos8_image" {
  description = "Path to Centos qcow2 to use"
  type        = string
}

