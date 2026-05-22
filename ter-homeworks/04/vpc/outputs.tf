output "network_id" {
  value = yandex_vpc_network.this.id
}

output "subnets" {
  value = {
    for k, s in yandex_vpc_subnet.this :
    k => {
      id   = s.id
      zone = s.zone
      cidr = s.v4_cidr_blocks[0]
    }
  }
}
