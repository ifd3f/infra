
provider "oci" {
  auth                = "SecurityToken"
  config_file_profile = var.oracle_config_file_profile
}

resource "oci_identity_compartment" "main" {
  name        = "Cloud"
  description = "Cloud"
}

locals {
  free_micro_instances = 2
  ubuntu_ocid    = "ocid1.image.oc1.us-sanjose-1.aaaaaaaa2jqekrtzkdvdksptigewqirjmdtfbpuqcoifn5smxsswrotvpufq"
  compartment_id = oci_identity_compartment.main.compartment_id
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

// Our always-free micro instances
resource "oci_core_instance" "micro_instances" {
  count = local.free_micro_instances

  display_name        = "oci${count.index}.h.astrid.tech"
  availability_domain = "JlTe:US-SANJOSE-1-AD-1"
  compartment_id      = local.compartment_id
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id      = oci_core_subnet.main.id
  }

  source_details {
    source_id               = local.ubuntu_ocid
    source_type             = "image"
    boot_volume_size_in_gbs = 50
  }
}
