# ============================================================
# Data source: актуальный образ Ubuntu 22.04 LTS
# ============================================================
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# ============================================================
# VPC
# ============================================================
resource "yandex_vpc_network" "vpc" {
  name = "my-vpc"
}

# ============================================================
# Static public IP для NAT-инстанса
# ============================================================
resource "yandex_vpc_address" "nat_ip" {
  name = "nat-public-ip"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

# ============================================================
# Публичная подсеть 192.168.10.0/24
# ============================================================
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# ============================================================
# Приватная подсеть 192.168.20.0/24
# ============================================================
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat_route.id
}

# ============================================================
# Route table — весь трафик через NAT-инстанс
# ============================================================
resource "yandex_vpc_route_table" "nat_route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

# ============================================================
# Security Group
# ============================================================
resource "yandex_vpc_security_group" "nat_sg" {
  name       = "nat-sg"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "ICMP"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "All from private subnet"
    protocol       = "ANY"
    v4_cidr_blocks = ["192.168.20.0/24"]
  }

  egress {
    description    = "All outbound"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ============================================================
# NAT-инстанс
# ============================================================
resource "yandex_compute_instance" "nat_instance" {
  name        = "nat-instance"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = "192.168.10.254"
    nat                = true
    nat_ip_address     = yandex_vpc_address.nat_ip.external_ipv4_address[0].address
    security_group_ids = [yandex_vpc_security_group.nat_sg.id]
  }

  metadata = {
    ssh-keys           = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    user-data          = "#cloud-config\nssh_pwauth: true\nchpasswd:\n  list: |\n    ubuntu:ubuntu123\n  expire: false"
    serial-port-enable = "1"
  }
}

# ============================================================
# Публичная ВМ
# ============================================================
resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.nat_sg.id]
  }

  metadata = {
    ssh-keys           = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    user-data          = "#cloud-config\nssh_pwauth: true\nchpasswd:\n  list: |\n    ubuntu:ubuntu123\n  expire: false"
    serial-port-enable = "1"
  }
}

# ============================================================
# Приватная ВМ
# ============================================================
resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.nat_sg.id]
  }

  metadata = {
    ssh-keys           = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    user-data          = "#cloud-config\nssh_pwauth: true\nchpasswd:\n  list: |\n    ubuntu:ubuntu123\n  expire: false"
    serial-port-enable = "1"
  }
}

# ============================================================
# Outputs
# ============================================================
output "nat_instance_external_ip" {
  value = yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address
}

output "public_vm_external_ip" {
  value = yandex_compute_instance.public_vm.network_interface.0.nat_ip_address
}

output "public_vm_internal_ip" {
  value = yandex_compute_instance.public_vm.network_interface.0.ip_address
}

output "private_vm_internal_ip" {
  value = yandex_compute_instance.private_vm.network_interface.0.ip_address
}
