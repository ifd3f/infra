output "instance_ips" {
  value = oci_core_instance.micro_instances.*.public_ip
}
