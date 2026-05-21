# Задание 1

<img width="602" height="74" alt="image" src="https://github.com/user-attachments/assets/69df78fa-d4fd-496a-86b5-1e6d1c673543" />

**Проверка работоспособности Nginx на 1 ВМ**

<img width="600" height="70" alt="image" src="https://github.com/user-attachments/assets/a7b75ec5-ea98-4119-8e61-0e4a1def7cba" />

**Проверка работоспособности Nginx на 2 ВМ**

<img width="1860" height="200" alt="image" src="https://github.com/user-attachments/assets/360f8392-5633-442d-81ab-a9955f9870a3" />

**Вывод виртуальных машин в Yandex Cloud**

<img width="624" height="946" alt="image" src="https://github.com/user-attachments/assets/521d5d23-b0ec-4d9b-aa1f-76e8b3fbed50" />

**Вывод содержимого модуля marketing**

# Задание 2

<img width="553" height="167" alt="image" src="https://github.com/user-attachments/assets/6c3a0c36-562c-4cff-aa5f-8c7d6bbdac58" />

**Информация о модуле**

<img width="1208" height="698" alt="image" src="https://github.com/user-attachments/assets/383195ed-c263-4a2c-9199-342a11dc8c9a" />

**Документация к модулю**

# Задание 3

<img width="578" height="147" alt="image" src="https://github.com/user-attachments/assets/0133bb13-f40f-4ec2-9e60-50632053112b" />

**Список всех ресурсов в terraform.tfstate**

<img width="971" height="445" alt="image" src="https://github.com/user-attachments/assets/f927f256-7cf6-4e29-a314-af52d3d38b90" />

**Удаление ресурсов**

<img width="1131" height="954" alt="image" src="https://github.com/user-attachments/assets/61e69df1-bdd3-42e2-9f66-998143694c06" />

**Импорт ресурсов**

<img width="1152" height="256" alt="image" src="https://github.com/user-attachments/assets/9e1e981b-3dac-4a09-849f-9244112978b9" />

**Проверка плана**

# Задание 4

Код:

mustway@mustway-server:~/ter-hw04-project$ cat vpc/variables.tf
variable "env_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnets" {
  description = "List of subnets with zone and CIDR"
  type = list(object({
    zone = string
    cidr = string
  }))
  default = []
}
mustway@mustway-server:~/ter-hw04-project$ cat vpc/main.tf
resource "yandex_vpc_network" "this" {
  name = var.env_name
}

resource "yandex_vpc_subnet" "this" {
  for_each = { for idx, s in var.subnets : s.zone => s }

  name           = "${var.env_name}-${each.key}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [each.value.cidr]
}
mustway@mustway-server:~/ter-hw04-project$ cat vpc/outputs.tf
output "network_id" {
  description = "ID of the created VPC network"
  value       = yandex_vpc_network.this.id
}

output "subnets" {
  description = "Map of created subnets by zone"
  value = {
    for k, s in yandex_vpc_subnet.this :
    k => {
      id   = s.id
      name = s.name
      zone = s.zone
      cidr = s.v4_cidr_blocks[0]
    }
  }
}
mustway@mustway-server:~/ter-hw04-project$ cat main.tf
# Провайдер и cloud-init не нужны для демонстрации VPC, 
# но оставим providers.tf как есть. А модули объявим здесь.

module "vpc_prod" {
  source   = "./vpc"
  env_name = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.11.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.12.0/24" },
  ]
}

module "vpc_dev" {
  source   = "./vpc"
  env_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.21.0/24" },
  ]
}

<img width="671" height="1000" alt="image" src="https://github.com/user-attachments/assets/aea1299a-a713-4686-a769-5dfb0a887a05" />

**Проверка плана**

<img width="1167" height="506" alt="image" src="https://github.com/user-attachments/assets/dd5df99d-d1f0-4c63-882a-e77d5d62b43a" />

**Вывод списка сетей и подсетей**

# Задание 5

<img width="1254" height="997" alt="image" src="https://github.com/user-attachments/assets/154384fc-fd61-4f6f-bdf8-6d74c9735f35" />

**Проверка плана**

<img width="1502" height="496" alt="image" src="https://github.com/user-attachments/assets/f58bca1a-358c-493d-9f2e-52ea05cc2c66" />

**Просмотр кластера**

# Задание 6

<img width="1033" height="116" alt="image" src="https://github.com/user-attachments/assets/c8c081a6-93b1-445a-a702-7101a0e590eb" />

**Просмотр списка бакетов**

# Задание 7

<img width="1851" height="563" alt="image" src="https://github.com/user-attachments/assets/f7504135-f6c8-4eef-9915-608e13f1a6f6" />

**Вывод секрета**

# Задание 8

