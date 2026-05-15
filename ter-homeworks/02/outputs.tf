output "vms_info" {
  description = "Instance name, internal IP and FQDN for each VM"
  value = {
    for instance in [
      yandex_compute_instance.platform,
      yandex_compute_instance.db
      ] : instance.name => {
      instance_name = instance.name
      internal_ip   = instance.network_interface[0].ip_address
      fqdn          = instance.fqdn
    }
  }
}

output "nat_gateway_info" {
  description = "NAT gateway details"
  value = {
    name = yandex_vpc_gateway.nat_gateway.name
    id   = yandex_vpc_gateway.nat_gateway.id
  }
}
