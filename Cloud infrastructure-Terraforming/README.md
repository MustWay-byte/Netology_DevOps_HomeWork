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

**В консоли Yandex Cloud: Container Registry**

<img width="880" height="193" alt="image" src="https://github.com/user-attachments/assets/008a3f6d-cf7a-4d19-8753-eedb3674c98b" />

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
```text
http://111.88.246.121
```

<img width="1847" height="1036" alt="image" src="https://github.com/user-attachments/assets/bb5cd213-7355-47ab-9d8c-6a7b75f9e569" />

---

## Задание 5*. Хранение паролей в LockBox и интеграция с Terraform

В пятом задании пароль для БД хранится в LockBox.  
Terraform использует пароль для создания и настройки пользователя базы данных.

В LockBox созданы ключи:
- `db_password`;
- `DB_PASSWORD`.

Оба значения синхронизированы с текущим паролем БД.

### Команды для проверки

**Проверка LockBox**
```bash
yc lockbox secret list
yc lockbox payload get --name netology-db-secret
```

**Проверка Terraform**
```bash
cd terraform
terraform init
terraform state list
terraform plan
terraform apply
```

### Скриншоты

**Проверка Terraform**
```bash
cd terraform
terraform init
terraform state list
terraform plan
terraform apply
```

<img width="1770" height="970" alt="image" src="https://github.com/user-attachments/assets/b60d22a7-4eb2-4d60-b9b3-9ea0251a3dde" />

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

# Итоговый проект: развертывание web-приложения в Yandex Cloud

## Описание проекта

В рамках итогового проекта было развернуто web-приложение в облачной инфраструктуре Yandex Cloud с использованием Terraform, Docker и Docker Compose.

Проект включает:
- создание сети VPC и подсетей;
- создание виртуальной машины;
- настройку групп безопасности;
- развертывание Managed MySQL;
- создание Container Registry;
- сборку Docker-образа web-приложения;
- публикацию образа в Container Registry;
- запуск приложения на виртуальной машине;
- подключение приложения к базе данных MySQL.

## Архитектура решения

Инфраструктура создана через Terraform без хардкода.  
Состояние Terraform хранится удаленно в Yandex Object Storage.  
Docker и Docker Compose устанавливаются на виртуальной машине через cloud-init.  
Web-приложение запускается в контейнере и подключается к Managed MySQL в Yandex Cloud.

## Структура репозитория

- `terraform/` — конфигурация инфраструктуры;
- `app/` — исходный код web-приложения, Dockerfile и docker-compose.yml;
- `README.md` — описание проекта и результаты выполнения.

## Использованные ресурсы Yandex Cloud

- VPC;
- подсеть;
- виртуальная машина на Ubuntu 20.04;
- Security Group;
- Managed MySQL;
- Container Registry;
- Object Storage для Terraform state.

## Развертывание

### 1. Инициализация Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Сборка Docker-образа

```bash
cd app
docker build -t netology-app:latest .
```

### 3. Публикация в Container Registry

```bash
docker tag netology-app:latest cr.yandex/<registry_id>/netology-app:latest
docker push cr.yandex/<registry_id>/netology-app:latest
```

### 4. Запуск приложения на VM

На виртуальной машине:

```bash
docker compose down
docker compose up -d
docker ps
```

### 5. Проверка работы

```bash
curl http://localhost
```

## Результат

Web-приложение успешно развернуто в Yandex Cloud и доступно по IP-адресу виртуальной машины через порт 80.  
Приложение корректно подключается к Managed MySQL и получает данные о версии MySQL.

## Проверка работы

При обращении к приложению отображается статус подключения к базе данных.  
Если соединение успешно, на странице отображается сообщение о том, что подключение к MySQL выполнено успешно, а также версия MySQL.

## Скриншоты и проверки

Ниже приведены команды и скриншоты, подтверждающие создание инфраструктуры, запуск приложения и подключение к базе данных.

### 1. Проверка виртуальной машины

```bash
yc compute instance list
```

<img width="876" height="112" alt="image" src="https://github.com/user-attachments/assets/080c14ef-e6e2-4491-90d7-2b2ecd7a7515" />

**На скриншоте видно, что VM создана и находится в состоянии `RUNNING`**

### 2. Проверка Managed MySQL

```bash
yc managed-mysql cluster list
yc managed-mysql user list --cluster-name netology-mysql
```

<img width="1162" height="228" alt="image" src="https://github.com/user-attachments/assets/98943769-0722-4ff2-960b-4f85d210055c" />

**На скриншоте видно, что кластер базы данных создан и пользователь `appuser` имеет права на базу `appdb`**

### 3. Проверка Container Registry

```bash
yc container registry list
yc container image list --repository-name crp814amdni497ck780u/netology-app
```

<img width="1336" height="284" alt="image" src="https://github.com/user-attachments/assets/943b89cc-7a25-4b8f-9e44-3a8cb0609f08" />

**На скриншоте видно, что образ web-приложения загружен в Container Registry**

### 4. Проверка Docker на VM

```bash
docker ps
```

<img width="1508" height="59" alt="image" src="https://github.com/user-attachments/assets/bed32783-fc91-4f8a-98c9-9d4ed55c7412" />

**На скриншоте видно, что контейнер приложения запущен и порт `80` проброшен наружу**

### 5. Проверка работы приложения локально

```bash
curl http://localhost
```
<img width="710" height="978" alt="image" src="https://github.com/user-attachments/assets/d8d2ca83-495f-4b6b-9e56-cb68d10af70b" />

**На скриншоте видно HTML-страницу приложения и статус подключения к MySQL**

### 6. Проверка работы приложения в браузере

Открой в браузере адрес:

```text
http://111.88.246.121
```

<img width="1847" height="1036" alt="image" src="https://github.com/user-attachments/assets/bb5cd213-7355-47ab-9d8c-6a7b75f9e569" />

**На скриншоте видно, что приложение открывается по IP-адресу машины и показывает статус подключения к MySQL**

### 7. Проверка облачной инфраструктуры в консоли Yandex Cloud

Скриншотами зафиксированы:

<img width="1818" height="185" alt="image" src="https://github.com/user-attachments/assets/e58b56a9-4bc5-4d87-8529-e3dd50a7c976" />

**- виртуальная машина;**

<img width="1263" height="352" alt="image" src="https://github.com/user-attachments/assets/a580c005-0535-40fd-8cac-172a5e3f8c53" />

**- подсеть;**
  
<img width="1248" height="246" alt="image" src="https://github.com/user-attachments/assets/4a54d03f-0051-4e90-92c7-053ae43bb874" />

**- security group;**

<img width="1050" height="191" alt="image" src="https://github.com/user-attachments/assets/406a11f6-a833-41e9-955d-034be945874e" />

**- кластер Managed MySQL;**

<img width="880" height="193" alt="image" src="https://github.com/user-attachments/assets/008a3f6d-cf7a-4d19-8753-eedb3674c98b" />

**- Container Registry.**

### 8. Проверка Terraform

```bash
terraform init
terraform plan
terraform apply
```

<img width="1770" height="970" alt="image" src="https://github.com/user-attachments/assets/b60d22a7-4eb2-4d60-b9b3-9ea0251a3dde" />

**На скриншоте видно успешное применение конфигурации Terraform без ошибок**

## Заключение

В ходе выполнения проекта были закреплены навыки работы с Terraform, Docker, Docker Compose и Yandex Cloud.  
Было выполнено развертывание приложения в облачной инфраструктуре с использованием управляемой базы данных и контейнерного реестра.
