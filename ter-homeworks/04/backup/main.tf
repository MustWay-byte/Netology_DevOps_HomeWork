variable "ssh_public_key" {
  type    = string
  default = ""
}

# Модули VPC
module "vpc_marketing" {
  source   = "./vpc"
  env_name = "develop-marketing"
  zone     = "ru-central1-a"
  cidr     = "10.0.1.0/24"
}

module "vpc_analytics" {
  source   = "./vpc"
  env_name = "develop-analytics"
  zone     = "ru-central1-b"
  cidr     = "10.0.2.0/24"
}

# Cloud-init шаблон
data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")
  vars = {
    ssh_public_key = var.ssh_public_key
  }
}

# Виртуальная машина marketing
resource "yandex_compute_instance" "marketing" {
  name        = "marketing-web-marketing-0"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname    = "marketing-web-marketing-0"

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
    subnet_id = module.vpc_marketing.subnet_id
    nat       = true
  }

  metadata = {
    user-data = data.template_file.cloudinit.rendered
  }

  labels = {
    project = "marketing"
  }

  scheduling_policy {
    preemptible = true
  }
}

# Виртуальная машина analytics
resource "yandex_compute_instance" "analytics" {
  name        = "analytics-web-analytics-0"
  platform_id = "standard-v1"
  zone        = "ru-central1-b"
  hostname    = "analytics-web-analytics-0"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8sjgpd03nsicrg3tlt"
      size     = 10
    }
  }

  network_interface {
    subnet_id = module.vpc_analytics.subnet_id
    nat       = true
  }

  metadata = {
    user-data = data.template_file.cloudinit.rendered
  }

  labels = {
    project = "analytics"
  }

  scheduling_policy {
    preemptible = true
  }
}

# Демонстрация нового модуля vpc (prod и dev)
module "vpc_prod" {
  source   = "./vpc"
  env_name = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.11.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.12.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.13.0/24" },
  ]
}

module "vpc_dev" {
  source   = "./vpc"
  env_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.21.0/24" },
  ]
}

# Демонстрационные модули для задания 4
module "vpc_prod" {
  source   = "./vpc"
  env_name = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.11.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.12.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.13.0/24" },
  ]
}

module "vpc_dev" {
  source   = "./vpc"
  env_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.21.0/24" },
  ]
}
