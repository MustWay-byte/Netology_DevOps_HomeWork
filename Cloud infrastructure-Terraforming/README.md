# Итоговый проект: развертывание web-приложения в Yandex Cloud

## Описание проекта

В рамках итогового проекта было развернуто web-приложение в облачной инфраструктуре Yandex Cloud с использованием Terraform, Docker и Docker Compose.

Проект включает:
- создание Virtual Private Cloud и подсетей;
- создание виртуальной машины;
- настройку групп безопасности;
- развертывание Managed MySQL;
- создание Container Registry;
- установку Docker и Docker Compose через cloud-init;
- сборку Docker-образа web-приложения;
- публикацию образа в Container Registry;
- запуск приложения на виртуальной машине;
- подключение приложения к базе данных MySQL;
- хранение паролей БД в LockBox и получение значения через Terraform.

## Архитектура решения

Инфраструктура описана через Terraform без хардкода.  
Состояние Terraform хранится удаленно в Yandex Object Storage, также используется statelocking.  
Docker и Docker Compose устанавливаются на виртуальной машине через cloud-init.  
Web-приложение запускается в контейнере и подключается к Managed MySQL в Yandex Cloud.  
Пароль БД хранится в LockBox и используется в Terraform через секрет.

## Структура репозитория

- `terraform/` — конфигурация инфраструктуры;
- `app/` — исходный код web-приложения, Dockerfile и `docker-compose.yml`;
- `README.md` — описание проекта и результаты выполнения.

---

## Задание 1. Развертывание инфраструктуры в Yandex Cloud

В рамках первого задания были созданы основные ресурсы инфраструктуры:
- Virtual Private Cloud;
- подсеть;
- виртуальная машина;
- группа безопасности;
- Managed MySQL;
- Container Registry.

Группа безопасности настроена для доступа по портам:
- `22` — SSH;
- `80` — HTTP;
- `443` — HTTPS.

Виртуальная машина привязана к группе безопасности и используется как хост для запуска web-приложения.

### Команды для проверки

```bash
yc compute instance list
yc vpc network list
yc vpc subnet list
yc vpc security-group list
yc managed-mysql cluster list
yc container registry list
```

### Скриншоты

**Проверка виртуальной машины**
```bash
yc compute instance list
```

<img width="876" height="112" alt="image" src="https://github.com/user-attachments/assets/080c14ef-e6e2-4491-90d7-2b2ecd7a7515" />

**В консоли Yandex Cloud: виртуальная машина**

<img width="1818" height="185" alt="image" src="https://github.com/user-attachments/assets/e58b56a9-4bc5-4d87-8529-e3dd50a7c976" />

**В консоли Yandex Cloud: подсеть**

<img width="1263" height="352" alt="image" src="https://github.com/user-attachments/assets/a580c005-0535-40fd-8cac-172a5e3f8c53" />

**В консоли Yandex Cloud: security group**

<img width="1248" height="246" alt="image" src="https://github.com/user-attachments/assets/4a54d03f-0051-4e90-92c7-053ae43bb874" />

**Проверка Managed MySQL**
```bash
yc managed-mysql cluster list
yc managed-mysql user list --cluster-name netology-mysql
```

<img width="1162" height="228" alt="image" src="https://github.com/user-attachments/assets/98943769-0722-4ff2-960b-4f85d210055c" />

**В консоли Yandex Cloud: кластер Managed MySQL**

<img width="1050" height="191" alt="image" src="https://github.com/user-attachments/assets/406a11f6-a833-41e9-955d-034be945874e" />

### Создание базы данных MySQL в Yandex Cloud

Для хранения данных приложения была создана управляемая база данных **MySQL** с использованием сервиса **Yandex Managed Service for MySQL**. Этот вариант был выбран вместо самостоятельной установки MySQL на отдельную VM, так как managed-сервис упрощает администрирование и снимает часть эксплуатационных задач.

При создании БД были заданы:
- имя кластера MySQL;
- зона размещения;
- конфигурация хостов;
- имя базы данных;
- пользователь базы данных;
- пароль пользователя.

После создания кластера был получен сетевой адрес MySQL-хоста, который затем использовался в приложении через переменную окружения `DB_HOST`. Подключение приложения к базе данных выполнялось по порту `3306`.

Использование managed-базы позволило:
- не администрировать MySQL вручную;
- использовать готовую управляемую инфраструктуру;
- подключать приложение по внутреннему адресу в рамках облачной сети.

**В консоли Yandex Cloud: Container Registry**

<img width="880" height="193" alt="image" src="https://github.com/user-attachments/assets/008a3f6d-cf7a-4d19-8753-eedb3674c98b" />

### Создание Container Registry

Для хранения контейнерного образа приложения был создан **Yandex Container Registry**. После создания registry в него был загружен Docker-образ web-приложения.

Container Registry использовался как приватное хранилище образов и решал следующие задачи:
- централизованное хранение собранного образа;
- доставка образа на виртуальную машину без локальной сборки;
- возможность повторного развертывания приложения из уже готового образа.

После создания registry был получен адрес вида `cr.yandex/...`, который использовался при тегировании и публикации контейнерного образа.

---

## Задание 2. Установка Docker и Docker Compose через cloud-init

Во втором задании Docker и Docker Compose устанавливаются автоматически при создании виртуальной машины через `cloud-init`.

В `cloud-init.yml` выполнены:
- установка Docker;
- установка Docker Compose plugin;
- запуск и включение Docker service;
- добавление пользователя `ubuntu` в группу `docker`.

### Команды для проверки

```bash
cat terraform/cloud-init.yml
docker --version
docker compose version
systemctl status docker
```

### Скриншоты

**Проверка Docker на VM**
```bash
docker ps
```

<img width="1508" height="59" alt="image" src="https://github.com/user-attachments/assets/bed32783-fc91-4f8a-98c9-9d4ed55c7412" />

---

## Задание 3. Dockerfile и сохранение образа в Container Registry

В третьем задании был описан Dockerfile для web-приложения.  
Dockerfile использует мультисборку и подготавливает контейнер для запуска приложения.

После сборки образ сохраняется в Yandex Container Registry.

### Команды для проверки

**Проверка Dockerfile**
```bash
cat app/Dockerfile
```

**Сборка образа**
```bash
cd app
docker build -t netology-app:latest .
```

**Публикация образа в Container Registry**
```bash
docker tag netology-app:latest cr.yandex/<registry_id>/netology-app:latest
docker push cr.yandex/<registry_id>/netology-app:latest
```

**Проверка образов в реестре**
```bash
yc container registry list
yc container image list --repository-name crp814amdni497ck780u/netology-app
```

### Скриншоты

**Проверка Container Registry**
```bash
yc container registry list
yc container image list --repository-name crp814amdni497ck780u/netology-app
```

<img width="1336" height="284" alt="image" src="https://github.com/user-attachments/assets/943b89cc-7a25-4b8f-9e44-3a8cb0609f08" />

### Создание Dockerfile

Для контейнеризации web-приложения был создан файл **Dockerfile**. Он описывает процесс сборки контейнера, внутри которого запускается Python/Flask-приложение.

Логика Dockerfile была следующей:

1. В качестве базового образа использовался Python.
2. В контейнер копировался файл `requirements.txt`.
3. Выполнялась установка зависимостей Python через `pip`.
4. В контейнер копировались остальные файлы приложения, включая `app.py` и шаблоны из каталога `templates`.
5. Открывался порт, на котором работает приложение.
6. Задавалась команда запуска приложения.

Таким образом Dockerfile обеспечивал переносимость приложения и создавал единое исполняемое окружение, независимое от локальной конфигурации сервера.

---

## Задание 4. Подключение приложения в контейнере к БД в Yandex Cloud

В четвертом задании web-приложение запускается в контейнере и подключается к Managed MySQL в Yandex Cloud.

Приложение:
- читает параметры подключения из переменных окружения;
- использует MySQL host, user, password и database;
- проверяет подключение к БД при запуске.

### Команды для проверки

**Проверка параметров подключения в приложении**
```bash
grep -nE 'DB_PASSWORD|host=|user=|password=' app/app.py
```

**Запуск контейнера**
```bash
docker compose down
docker compose up -d
docker ps
```

**Проверка приложения локально**
```bash
curl http://localhost
```

**Проверка приложения по внешнему IP**
```bash
curl http://111.88.246.121
```

### Скриншоты

**Контейнер приложения запущен**
```bash
docker ps
```

<img width="1508" height="59" alt="image" src="https://github.com/user-attachments/assets/bed32783-fc91-4f8a-98c9-9d4ed55c7412" />

**Проверка работы приложения локально**
```bash
curl http://localhost
```

<img width="710" height="978" alt="image" src="https://github.com/user-attachments/assets/d8d2ca83-495f-4b6b-9e56-cb68d10af70b" />

**Проверка работы приложения в браузере**

[http://111.88.246.121](http://111.88.246.121)

<img width="1847" height="1036" alt="image" src="https://github.com/user-attachments/assets/bb5cd213-7355-47ab-9d8c-6a7b75f9e569" />

---

## Задание 5*. Хранение паролей в LockBox и интеграция с Terraform

В пятом задании пароль для БД хранится в LockBox.  
Terraform использует этот пароль при создании и настройке пользователя базы данных.

В LockBox создан секрет `netology-db-secret`, который содержит актуальные параметры подключения к БД.

### Команды для проверки

**Проверка LockBox**
```bash
yc lockbox secret list
```

**Проверка пользователя БД через Terraform**
```bash
terraform state show yandex_mdb_mysql_user.appuser
```

### Скриншоты

**Проверка LockBox**
```bash
yc lockbox secret list
```

<img width="1219" height="133" alt="image" src="https://github.com/user-attachments/assets/59d59c25-8a64-4c27-88b4-37a3ba571e6d" />

**Проверка пользователя БД**
```bash
terraform state show yandex_mdb_mysql_user.appuser
```

<img width="1467" height="371" alt="image" src="https://github.com/user-attachments/assets/28efcc3a-f895-4332-b6b9-c0f58706afc0" />

---

## Итоговая проверка проекта

В результате выполнения проекта:
- инфраструктура в Yandex Cloud описана через Terraform;
- state Terraform хранится удаленно;
- используется statelocking;
- Docker и Docker Compose устанавливаются через cloud-init;
- Dockerfile использует мультисборку;
- образ приложения загружен в Container Registry;
- приложение доступно по внешнему IP-адресу виртуальной машины;
- приложение подключается к Managed MySQL;
- пароль БД хранится в LockBox;
- код проекта хранится в Git-репозитории.

## Заключение

В ходе выполнения проекта были закреплены навыки работы с Terraform, Docker, Docker Compose и Yandex Cloud.  
Было выполнено развертывание приложения в облачной инфраструктуре с использованием управляемой базы данных, контейнерного реестра и защищенного хранения секретов.
