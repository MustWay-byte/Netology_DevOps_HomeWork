# ============================================================
# VPC и подсети в разных зонах
# ============================================================
resource "yandex_vpc_network" "mysql_net" {
  name = "mysql-network"
}

resource "yandex_vpc_subnet" "mysql_subnet_a" {
  name           = "mysql-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.mysql_net.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}

resource "yandex_vpc_subnet" "mysql_subnet_b" {
  name           = "mysql-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.mysql_net.id
  v4_cidr_blocks = ["10.10.2.0/24"]
}

resource "yandex_vpc_subnet" "mysql_subnet_d" {
  name           = "mysql-subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.mysql_net.id
  v4_cidr_blocks = ["10.10.3.0/24"]
}

resource "yandex_vpc_security_group" "mysql_sg" {
  name       = "mysql-security-group"
  network_id = yandex_vpc_network.mysql_net.id

  ingress {
    description    = "MySQL"
    protocol       = "TCP"
    port           = 3306
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "All outbound"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ============================================================
# Кластер MySQL
# ============================================================
resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name               = "netology-mysql-cluster"
  environment        = "PRESTABLE"
  network_id         = yandex_vpc_network.mysql_net.id
  version            = "8.0"
  security_group_ids = [yandex_vpc_security_group.mysql_sg.id]

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 3
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  deletion_protection = true

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.mysql_subnet_a.id
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.mysql_subnet_b.id
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.mysql_subnet_a.id
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "netology_user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "netology_user"
  password   = var.db_password

  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}

# ============================================================
# Outputs
# ============================================================
output "mysql_cluster_id" {
  value = yandex_mdb_mysql_cluster.mysql_cluster.id
}

output "mysql_host_fqdns" {
  value = yandex_mdb_mysql_cluster.mysql_cluster.host[*].fqdn
}
