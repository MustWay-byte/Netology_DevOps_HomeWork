# Задание 1

Согласно .gitignore, комментарий # own secret vars store. подразумевает, что за пределами скопированного вывода находится строка с исключением, разрешающая хранение секретов в конкретном файле. В исходном репозитории после этого комментария идёт: "text !personal.auto.tfvars".Таким образом, несмотря на общее правило игнорировать все файлы с расширением .tfvars, именно personal.auto.tfvars разрешён для отслеживания Git, и в него допустимо сохранять личную/секретную информацию (логины, пароли, токены и т.п.). Любой файл с именем *.auto.tfvars автоматически загружается Terraform, поэтому переменные из него становятся доступными в коде. Правило !personal.auto.tfvars в .gitignore отменяет действие предыдущих игнорирующих шаблонов именно для этого файла. Таким образом, возможно определить в нём секретные значения через переменные, и они не будут случайно закоммичены, если разработчик явно не добавит этот файл в Git (но технически добавление такого файла разрешено, и он расценивается как «собственное хранилище секретов»).

Ключ: "result": "rOqY1eSA7Ty7d3Fp"

Намеренно допущенные ошибки:

1) Пропущено имя ресурса в docker_image. Без имени Terraform не понимает, какой ресурс создать.

2) Имя ресурса "1nginx" начинается с цифры в docker_container. Имена ресурсов должны начинаться с буквы или подчёркивания.

3) Ссылка на несуществующий ресурс random_password.random_string_FAKE. Есть только random_password.random_string. Опечатка _FAKE.

4) Опечатка в атрибуте resulT (заглавная T). Правильный атрибут — result (строчная t). Terraform регистрозависимый, resulT не существует.

Исправленный фрагмент кода:

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx_container" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}

mustway@mustway-server:~/ter-homeworks/01/src$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
8847cfc13367   5dfe511714e1   "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   0.0.0.0:9090->80/tcp   example_rOqY1eSA7Ty7d3Fp

Ключ -auto-approve заставляет Terraform пропустить интерактивный запрос подтверждения (обычный yes/no) и сразу выполнить план.

Риски:

1) Можно случайно применить разрушительные изменения (например, удалить базу данных или критичный ресурс), не успев прервать операцию.

2) В production это особенно опасно, так как даже небольшая ошибка в конфигурации или состоянии может привести к серьёзным простоям или потере данных.

3) При совместной работе в команде автоматическое применение обходит код-ревью и проверку плана коллегами.

Где пригодится:

1) CI/CD-пайплайны - когда Terraform запускается из скриптов или систем автоматической доставки, и план уже был проверен на этапе terraform plan.

2) Тестовые и учебные среды, чтобы ускорить итерации.

3) Автоматическое восстановление инфраструктуры в сочетании с мониторингом.

<img width="736" height="118" alt="image" src="https://github.com/user-attachments/assets/c8335d0c-db4e-4c9a-838f-df423dfb1a7c" />

**Вывод Docker-контейнера**

mustway@mustway-server:~/ter-homeworks/01/src$ cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.15.2",
  "serial": 12,
  "lineage": "c88e0f8d-a0df-ca52-0b79-21205d7d3815",
  "outputs": {},
  "resources": [],
  "check_results": null
}

Образ не был удалён, потому что в коде ресурса docker_image явно задан параметр keep_locally = true. Именно строка keep_locally = true указывает провайдеру Docker сохранять образ в локальном хранилище после уничтожения ресурса. Это поведение полностью соответствует официальной документации. Согласно документации Terraform-провайдера Docker для ресурса docker_image: keep_locally - (Optional, boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.

# Задание 2

Согласно документации провайдера Docker, конфигурация для подключения по SSH выглядит так:

hcl
provider "docker" {
  host     = "ssh://yc-user@<публичный_IP_вашей_ВМ>:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

<img width="727" height="94" alt="image" src="https://github.com/user-attachments/assets/6d50abf8-060b-40ae-b84e-cbf392083742" />

**Вывод Docker-контейнера**

# Задание 3

Выполнение кода через opentofu:

mustway@mustway-server:~/ter-homeworks/01/src$ tofu apply
random_password.mysql_wordpress_password: Refreshing state... [id=none]
random_password.mysql_root_password: Refreshing state... [id=none]
docker_image.mysql: Refreshing state... [id=sha256:c36050afdca850f23cef85703f84c7531a5ae155a11b5ee1c60acb09937c4084mysql:8]

OpenTofu used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

OpenTofu will perform the following actions:

  # docker_container.mysql will be created
  + resource "docker_container" "mysql" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (sensitive value)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = "sha256:c36050afdca850f23cef85703f84c7531a5ae155a11b5ee1c60acb09937c4084"
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + memory_reservation                          = 0
      + must_run                                    = true
      + name                                        = "mysql"
      + network_data                                = (known after apply)
      + network_mode                                = "bridge"
      + platform                                    = (known after apply)
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels (known after apply)

      + ports {
          + external = 3306
          + internal = 3306
          + ip       = "127.0.0.1"
          + protocol = "tcp"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  OpenTofu will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

docker_container.mysql: Creating...
docker_container.mysql: Creation complete after 1s [id=b9c39cf8647fa3777fe63962ecb218520ce9b8a37deff7fa7fb0dc08faa2293e]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

<img width="734" height="116" alt="image" src="https://github.com/user-attachments/assets/579f5d0a-d958-47c5-8fdb-c62c0025e404" />

**Вывод Docker-контейнера**
