data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "/home/mustway/vpc-root/terraform.tfstate"
  }
}

resource "yandex_compute_instance" "web" {
  name        = "web-server"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8sjgpd03nsicrg3tlt"   # Ubuntu 20.04
      size     = 10
    }
  }

  network_interface {
    subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

output "external_ip" {
  value = yandex_compute_instance.web.network_interface.0.nat_ip_address
}
