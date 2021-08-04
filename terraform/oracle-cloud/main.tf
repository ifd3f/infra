
provider "oci" {
  auth                = "SecurityToken"
  config_file_profile = var.oracle_config_file_profile
}

resource "oci_identity_compartment" "compartment" {
  name        = "Cloud"
  description = "Cloud"
}

# resource "oci_core_instance" "i1" {
#     availability_domain = "JlTe:US-SANJOSE-1-AD-1"
#     compartment_id = oci_identity_compartment.compartment.compartment_id
#     shape = "VM.Standard.E2.1.Micro"
# 
# }
