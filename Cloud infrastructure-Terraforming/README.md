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

## Скриншоты

Скриншоты приведены ниже и подтверждают:
- создание инфраструктуры;
- запуск контейнера;
- доступность приложения;
- успешное подключение к базе данных;
- состояние ресурсов в Yandex Cloud.

<img width="792" height="155" alt="image" src="https://github.com/user-attachments/assets/2330ebc8-2cb3-4820-866e-ddd9a1b9f5f2" />

**Ввод команд в виртуальной машине**

## Заключение

В ходе выполнения проекта были закреплены навыки работы с Terraform, Docker, Docker Compose и Yandex Cloud.  
Было выполнено развертывание приложения в облачной инфраструктуре с использованием управляемой базы данных и контейнерного реестра.
