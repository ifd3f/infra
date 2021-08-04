
provider "oci" {
  auth                = "SecurityToken"
  config_file_profile = var.oracle_config_file_profile
}

resource "oci_identity_compartment" "main" {
  name        = "terraformed"
  description = "Terraform-created resources for the public cloud"
}

locals {
  free_micro_instances = 2
  ad                   = "JlTe:US-SANJOSE-1-AD-1"
  ubuntu_ocid          = "ocid1.image.oc1.us-sanjose-1.aaaaaaaa2jqekrtzkdvdksptigewqirjmdtfbpuqcoifn5smxsswrotvpufq"
  compartment_id       = oci_identity_compartment.main.compartment_id
}

resource "oci_core_vcn" "main" {
  display_name = "Main VCN"

  cidr_block     = "10.1.0.0/24"
  compartment_id = local.compartment_id
}

resource "oci_core_subnet" "main" {
  display_name = "Main Subnet"

  cidr_block     = "10.1.0.0/24"
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.main.id
}

resource "oci_core_instance" "micro_instance" {
  count = local.free_micro_instances

  display_name        = "oci-micro-${count.index}.h.astrid.tech"
  availability_domain = local.ad
  compartment_id      = local.compartment_id
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.main.id
    assign_public_ip = false
  }

  source_details {
    source_id               = local.ubuntu_ocid
    source_type             = "image"
    boot_volume_size_in_gbs = 50
  }
}

module "micro_instance_ips" {
  count = local.free_micro_instances
  source = "./reserved_ip_assignment"

  ad = local.ad
  compartment_id = local.compartment_id
  display_name = "micro-${count.index}"
  instance_id = oci_core_instance.micro_instance[count.index].id
}