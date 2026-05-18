resource "yandex_compute_disk" "additional" {
  count = 3
  name  = "disk-${count.index + 1}"
  size  = 1
  zone  = var.default_zone
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  zone        = var.default_zone
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = false
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.additional
    content {
      disk_id     = secondary_disk.value.id
      auto_delete = false
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}
