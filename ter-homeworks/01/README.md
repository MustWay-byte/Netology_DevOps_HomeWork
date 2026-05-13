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

