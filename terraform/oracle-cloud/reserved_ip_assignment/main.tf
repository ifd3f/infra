// Assigning public IPs: https://github.com/terraform-providers/terraform-provider-oci/issues/680

variable "ad" {
  type = string
}

variable "compartment_id" {
  type = string
}

variable "instance_id" {
  type = string
}

variable "display_name" {
  type = string
}

# Gets a list of VNIC attachments on the instance
data "oci_core_vnic_attachments" "micro_instance" {
  compartment_id      = var.compartment_id
  availability_domain = var.ad
  instance_id         = var.instance_id
}

# Gets the primary VNIC from the list of attachments
data "oci_core_vnic" "micro_instance" {
  vnic_id = lookup(data.oci_core_vnic_attachments.micro_instance.vnic_attachments[0], "vnic_id")
}

# Use the primary VNIC's OCID to get a list of private IPs assigned to it
data "oci_core_private_ips" "micro_instance" {
  vnic_id = data.oci_core_vnic.micro_instance.id
}

# Assign a reserved public IP to the private IP
resource "oci_core_public_ip" "micro_instance" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  lifetime       = "RESERVED"
  private_ip_id  = lookup(data.oci_core_private_ips.micro_instance.private_ips[0], "id")
}

