terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
  required_version = ">= 1.12.0"
}

# Переменные для подключения к удалённому Docker-хосту
variable "ssh_user" {
  type    = string
  default = "mustway"
}

variable "vm_ip" {
  type    = string
  # Значение передаётся через personal.auto.tfvars
}

# Провайдер Docker, подключающийся к ВМ по SSH
provider "docker" {
  host     = "ssh://${var.ssh_user}@${var.vm_ip}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

# Генерация случайных паролей
resource "random_password" "mysql_root_password" {
  length  = 16
  special = false
}

resource "random_password" "mysql_wordpress_password" {
  length  = 16
  special = false
}

# Скачиваем образ MySQL 8
resource "docker_image" "mysql" {
  name = "mysql:8"
}

# Запуск контейнера MySQL
resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "mysql"

  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_wordpress_password.result}",
    "MYSQL_ROOT_HOST=%",
  ]
}
