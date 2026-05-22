output "network_id" {
  description = "ID of the created VPC network"
  value       = yandex_vpc_network.this.id
}

output "subnets" {
  description = "Map of created subnets by zone"
  value = {
    for k, s in yandex_vpc_subnet.this :
    k => {
      id   = s.id
      name = s.name
      zone = s.zone
      cidr = s.v4_cidr_blocks[0]
    }
  }
}
