resource "yandex_compute_instance" "web" {
  count      = 2
  depends_on = [yandex_compute_instance.db] # ждём готовности всех db-ВМ

  name        = "web-${count.index + 1}" # web-1, web-2
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

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}
