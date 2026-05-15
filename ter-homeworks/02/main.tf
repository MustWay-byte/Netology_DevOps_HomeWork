resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
  route_table_id = yandex_vpc_route_table.nat_rt.id
}

resource "yandex_vpc_subnet" "develop_db" {
  name           = "${var.vpc_name}-db"
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  route_table_id = yandex_vpc_route_table.nat_rt.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "my-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "nat_rt" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.develop.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

resource "yandex_compute_instance" "platform" {
  name        = local.web_name
  platform_id = var.vm_web_platform_id
  zone        = var.vm_web_zone

  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["web"].hdd_size
      type     = var.vms_resources["web"].hdd_type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = false
  }

  metadata = {
    serial-port-enable = "1"
    enable-oslogin     = "false"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFO6A5x00jIaQ4AYk7oMvtC/QZPCM3EUf43FkJqU5Y1y netology-terraform"
    user-data          = <<-CLOUDCONFIG
      #cloud-config
      password: netology123
      chpasswd: { expire: False }
      ssh_pwauth: True
    CLOUDCONFIG
  }

  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
}

resource "yandex_compute_instance" "db" {
  name        = local.db_name
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone

  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["db"].hdd_size
      type     = var.vms_resources["db"].hdd_type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = false
  }

  metadata = {
    serial-port-enable = "1"
    enable-oslogin     = "false"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFO6A5x00jIaQ4AYk7oMvtC/QZPCM3EUf43FkJqU5Y1y netology-terraform"
    user-data          = <<-CLOUDCONFIG
      #cloud-config
      password: netology123
      chpasswd: { expire: False }
      ssh_pwauth: True
    CLOUDCONFIG
  }

  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
}
