data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_vpc_network" "network" {
  name = "netology-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "netology-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.10.10.0/24"]
}

resource "yandex_vpc_security_group" "web_sg" {
  name       = "netology-web-sg"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    protocol       = "ANY"
    description    = "All outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_container_registry" "registry" {
  name = "netology-registry"
}

resource "yandex_mdb_mysql_cluster" "mysql" {
  name        = "netology-mysql"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.network.id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  host {
    zone      = var.zone
    subnet_id = yandex_vpc_subnet.subnet.id
  }
}

resource "yandex_mdb_mysql_database" "appdb" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = "appdb"
}

resource "yandex_mdb_mysql_user" "appuser" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = "appuser"
  password   = var.db_password

  permission {
    database_name = yandex_mdb_mysql_database.appdb.name
    roles         = ["ALL"]
  }
}

resource "yandex_compute_instance" "vm" {
  name        = "netology-vm"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    ssh-keys  = "ubuntu:${file(pathexpand(var.public_key_path))}"
    user-data = file("${path.module}/cloud-init.yml")
  }
}

output "vm_external_ip" {
  value = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "registry_id" {
  value = yandex_container_registry.registry.id
}

output "mysql_fqdn" {
  value = yandex_mdb_mysql_cluster.mysql.host[0].fqdn
}
