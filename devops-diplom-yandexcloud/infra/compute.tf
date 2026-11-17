variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/k8s_rsa.pub"
}

variable "preemptible" {
  type    = bool
  default = false
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

# Раскладка под квоты аккаунта: по 1 ноде на зону a/d/e
# (в каждой зоне лимит 2 vCPU / 20 ГБ HDD; зона b закрыта)
locals {
  worker_subnets = [yandex_vpc_subnet.subnet_d.id, yandex_vpc_subnet.subnet_e.id]
  worker_zones   = ["ru-central1-d", "ru-central1-e"]
}

resource "yandex_compute_instance" "master" {
  name                      = "k8s-master-1"
  hostname                  = "k8s-master-1"
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_a.id
    security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
    nat                = true
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

resource "yandex_compute_instance" "worker" {
  count                     = 2
  name                      = "k8s-worker-${count.index + 1}"
  hostname                  = "k8s-worker-${count.index + 1}"
  platform_id               = "standard-v3"
  zone                      = local.worker_zones[count.index]
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = local.worker_subnets[count.index]
    security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
    nat                = true
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}
