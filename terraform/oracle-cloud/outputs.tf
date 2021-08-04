# output "reserved_ip" {
#     value = module.static_ip.assigned_ip
# }

output "micro_instance_ips" {
  value = oci_core_instance.micro_instance.*.public_ip
}
