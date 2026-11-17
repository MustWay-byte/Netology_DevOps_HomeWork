resource "yandex_vpc_subnet" "subnet_e" {
  name           = "k8s-subnet-e"
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.k8s_net.id
  v4_cidr_blocks = ["10.20.4.0/24"]
}
