# Дипломная работа

# Kubernetes в Yandex Cloud — Подготовка инфраструктуры через Terraform

Предварительная подготовка к установке и запуску Kubernetes-кластера в Yandex Cloud:
сервисный аккаунт для Terraform, S3-backend для state-файла и базовая сеть (VPC + подсети в трёх зонах доступности).

1. **`bootstrap/`** — «стартовая» конфигурация. Создаёт сервисный аккаунт `bucket-sa`
   с ролью `storage.admin` на каталог (минимально достаточные права для работы с Object Storage,
   **не** `admin`/`editor` на облако), статический ключ доступа для него и S3-бакет
   `mustway-tfstate-bucket-2026` для хранения state-файла. State самой bootstrap-конфигурации
   хранится локально (бакет для state создаётся этой же конфигурацией).
2. **`infra/`** — основная конфигурация. Использует созданный бакет как `backend "s3"`,
   создаёт VPC-сеть `k8s-network` и три подсети в зонах `ru-central1-a`, `ru-central1-b`, `ru-central1-d`.

Аутентификация провайдера Yandex Cloud в обеих конфигурациях — по авторизованному ключу
`key.json` существующего сервисного аккаунта `terraform-sa` (ключ **не** попадает в репозиторий).

### Структура проекта

```
yc-k8s-project/
├── bootstrap/                  # сервисный аккаунт, статический ключ, S3-бакет
│   ├── providers.tf            # провайдер yandex-cloud/yandex (>= 0.131.0)
│   ├── variables.tf            # cloud_id, folder_id
│   ├── terraform.tfvars        # значения переменных (не коммитится)
│   ├── main.tf                 # SA + роль storage.admin + static key + bucket
│   ├── outputs.tf              # bucket_name, access_key, secret_key (sensitive)
│   └── key.json                # ключ terraform-sa (не коммитится!)
└── infra/                      # основная инфраструктура, state в S3
    ├── providers.tf            # провайдер + backend "s3"
    ├── variables.tf
    ├── terraform.tfvars        # (не коммитится)
    ├── main.tf                 # VPC + 3 подсети
    └── key.json                # (не коммитится!)
```

Ключи доступа к бакету передаются через переменные окружения
`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` (из outputs bootstrap), поэтому в коде секретов нет.

### Сеть (`infra/main.tf`)

| Ресурс | Имя | Зона доступности | CIDR |
|---|---|---|---|
| `yandex_vpc_network.k8s_net` | `k8s-network` | — | — |
| `yandex_vpc_subnet.subnet_a` | `k8s-subnet-a` | `ru-central1-a` | `10.20.1.0/24` |
| `yandex_vpc_subnet.subnet_b` | `k8s-subnet-b` | `ru-central1-b` | `10.20.2.0/24` |
| `yandex_vpc_subnet.subnet_d` | `k8s-subnet-d` | `ru-central1-d` | `10.20.3.0/24` |

## Порядок запуска (с нуля)

### 1. Bootstrap — создаём SA, ключи и бакет

```bash
cd ~/yc-k8s-project/bootstrap
terraform init
terraform apply -auto-approve
# Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

# сохраняем outputs для настройки backend
terraform output -json > /tmp/tfstate-backend.json
```

### 2. Infra — инициализируем S3-backend и создаём сеть

```bash
cd ~/yc-k8s-project/infra

export AWS_ACCESS_KEY_ID=$(jq -r .access_key.value /tmp/tfstate-backend.json)
export AWS_SECRET_ACCESS_KEY=$(jq -r .secret_key.value /tmp/tfstate-backend.json)

terraform init      # Successfully configured the backend "s3"!
terraform plan
terraform apply -auto-approve
# Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

### 3. Проверка воспроизводимости (требование задания)

```bash
terraform destroy -auto-approve   # Destroy complete! Resources: 4 destroyed.
terraform apply   -auto-approve   # Apply complete! Resources: 4 added.
terraform plan                    # No changes. Your infrastructure matches the configuration.
```

Обе команды проходят **без ручных действий**: ключи backend берутся из окружения,
ключ провайдера — из `key.json`, state автоматически читается/пишется в бакет
`mustway-tfstate-bucket-2026/infra/terraform.tfstate`.

> `terraform destroy` в `infra/` удаляет только сеть и подсети — бакет со state остаётся,
> т.к. управляется отдельной конфигурацией `bootstrap/`. Полная очистка: сначала
> `destroy` в `infra/`, затем `destroy` в `bootstrap/`.

---

## Результаты

| Требование | Статус |
|---|---|
| Сервисный аккаунт с достаточными правами (не суперпользователь) |  `bucket-sa`, роль `storage.admin` на каталог |
| Backend — S3-бакет, созданный через Terraform |  `mustway-tfstate-bucket-2026` |
| Разные папки для bootstrap и основной конфигурации |  `bootstrap/` и `infra/` |
| VPC с подсетями в разных зонах доступности |  3 подсети: `ru-central1-a/b/d` |
| State основной конфигурации в бакете |  `s3://mustway-tfstate-bucket-2026/infra/terraform.tfstate` |
| `destroy` / `apply` без ручных действий |  проверено циклом destroy → apply → plan (no changes) |

Конфигурация предварительная и будет расширяться на следующих шагах (Kubernetes-кластер).

## Скриншоты

**Сервисные аккаунты**

<img width="1832" height="321" alt="image" src="https://github.com/user-attachments/assets/013ce2f0-b5f8-4fb3-9c8e-34711d097567" />

**Подсети в разных зонах**

<img width="1605" height="480" alt="image" src="https://github.com/user-attachments/assets/593e504a-e5db-4781-8e67-a7af5fd16ae6" />

**Бакет**

<img width="1045" height="203" alt="image" src="https://github.com/user-attachments/assets/a479cd16-1fe0-4c9c-b85c-467a5960f755" />

**Уничтожение облачной инфраструктуры**

<img width="617" height="851" alt="image" src="https://github.com/user-attachments/assets/1dd2fd78-c5b8-427e-9c3e-6e9eeec8e481" />

**Создание облачной инфраструктуры**

<img width="735" height="847" alt="image" src="https://github.com/user-attachments/assets/cb452b44-68e9-4642-9e87-c3e3436c898d" />

# Создание Kubernetes кластера (Kubespray)

Развёртывание production-ready Kubernetes-кластера (v1.36.x) на базе инфраструктуры Yandex Cloud с использованием Kubespray v2.32.0. Кластер состоит из 3 узлов (1 control-plane + 2 worker), размещённых в разных зонах доступности.

## Архитектура и ресурсы

| Нода | Зона | vCPU / RAM | Диск | Внутренний IP | Публичный IP |
|---|---|---|---|---|---|
| `k8s-master-1` | `ru-central1-a` | 2 / 4 GB | 20 GB HDD | `10.20.1.14` | `84.201.173.154` |
| `k8s-worker-1` | `ru-central1-d` | 2 / 4 GB | 20 GB HDD | `10.20.3.33` | `153.51.161.212` |
| `k8s-worker-2` | `ru-central1-e` | 2 / 4 GB | 20 GB HDD | `10.20.4.24` | `93.77.161.235`  |

> **Примечание:** Использованы диски `network-hdd` и зоны `d`/`e` из-за исчерпания квот на `network-ssd` и временной недоступности зоны `ru-central1-b` для новых ресурсов в данном аккаунте. Параметр `allow_stopping_for_update = true` позволяет менять тип инстанса через Terraform без ручных действий.

---

## Ключевые конфигурации Terraform

### Security Group (`security.tf`)
Обеспечивает доступ к API, SSH, NodePort и разрешает весь внутренний трафик между нодами кластера:
```hcl
resource "yandex_vpc_security_group" "k8s_sg" {
  name       = "k8s-sg"
  network_id = yandex_vpc_network.k8s_net.id

  ingress { protocol = "TCP"; port = 22; v4_cidr_blocks = ["0.0.0.0/0"] }
  ingress { protocol = "TCP"; port = 6443; v4_cidr_blocks = ["0.0.0.0/0"] }
  ingress { protocol = "TCP"; from_port = 30000; to_port = 32767; v4_cidr_blocks = ["0.0.0.0/0"] }
  ingress { protocol = "ANY"; from_port = 0; to_port = 65535; predefined_target = "self_security_group" }
  egress  { protocol = "ANY"; from_port = 0; to_port = 65535; v4_cidr_blocks = ["0.0.0.0/0"] }
}
```

## Результаты

| Требование | Статус |
|---|---|
| Минимум 3 ВМ через Terraform (1 master + 2 worker) | 3 ВМ созданы: `k8s-master-1`, `k8s-worker-1`, `k8s-worker-2` |
| ВМ размещены в разных зонах доступности | `ru-central1-a`, `ru-central1-d`, `ru-central1-e` |
| Возможность смены типа инстанса через Terraform | Параметр `allow_stopping_for_update = true` позволяет менять конфигурацию без ручных действий |
| Ansible-конфигурация (Kubespray) | v2.32.0, inventory генерируется автоматически из `terraform output` |
| Работоспособный Kubernetes-кластер | v1.36.4, containerd 2.3.5, сеть Calico (VXLAN) |
| Файл `~/.kube/config` с доступом к кластеру | `admin.conf` скопирован, публичный IP мастера добавлен в SAN сертификата API |
| Команда `kubectl get pods --all-namespaces` без ошибок | Все системные поды (`calico`, `coredns`, `etcd` и др.) в статусе `Running` |
| Доступ к ресурсам кластера из Интернета | Проверено через NodePort: `curl -I` вернул `HTTP/1.1 200 OK` |
| Решение проблем с квотами и блокировками IP | Выявлены через serial-консоль и ping, решены перевыпуском IP через `terraform apply -replace` |

## Скриншоты

**Виртуальные машины**

<img width="1822" height="299" alt="image" src="https://github.com/user-attachments/assets/2c8a1f7a-8557-4bc2-bb16-f40ccc7a62d1" />

**Статус нод кластера**

<img width="1371" height="95" alt="image" src="https://github.com/user-attachments/assets/85c20eee-6ede-44b7-a285-a90283a53ed7" />

**Статус системных подов**

<img width="870" height="330" alt="image" src="https://github.com/user-attachments/assets/8d2dcbeb-76b7-4f58-b3a3-fcd67893d6ee" />

**Доступ к ресурсам из Интернета**

<img width="407" height="200" alt="image" src="https://github.com/user-attachments/assets/85d80ee7-becd-430c-84c7-cd3dc50dc07e" />

# Создание тестового приложения и Container Registry

Подготовка тестового приложения, эмулирующего основной продукт компании, для последующего развертывания в Kubernetes. Приложение представляет собой легкий веб-сервер, упакованный в Docker-образ и размещенный в приватном реестре Yandex Cloud, который управляется через Terraform.

## Архитектура и ресурсы

| Компонент | Описание | Значение / Ссылка |
|---|---|---|
| **Репозиторий приложения** | Отдельный Git-репозиторий с исходным кодом тестового приложения | [Netology_Diplom_TestApp](https://github.com/MustWay-byte/Netology_Diplom_TestApp) |
| **Dockerfile** | Минималистичный образ на базе `nginx:1.25-alpine` с кастомным конфигом | `app/Dockerfile` |
| **Container Registry** | Приватный реестр образов Yandex Cloud, управляемый через Terraform | ID: `crpudopro8jpj70h8dn0` |
| **Собранные образы** | Тестовые теги для последующего деплоя | `cr.yandex/crpudopro8jpj70h8dn0/test-app:v1`<br>`cr.yandex/crpudopro8jpj70h8dn0/test-app:latest` |

---

## Ключевые конфигурации

### Dockerfile (`app/Dockerfile`)
Самостоятельно написанный файл для сборки образа. Удаляет дефолтный конфиг Nginx, добавляет кастомный `nginx.conf` и статическую страницу `index.html`.
```dockerfile
FROM nginx:1.25-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Управление реестром через Terraform (infra/registry.tf)
Ресурс реестра описан в коде и импортирован в состояние Terraform, что гарантирует идемпотентность и соответствие требованиям инфраструктуры как кода (IaC).

```hcl
resource "yandex_container_registry" "test_app_registry" {
  name      = "test-app-registry"
  folder_id = var.folder_id
}

output "registry_id" {
  description = "ID реестра контейнеров"
  value       = yandex_container_registry.test_app_registry.id
}
```

## Результаты

| Требование задания | Статус выполнения |
| :--- | :--- |
| **Отдельный git репозиторий с тестовым приложением** | Создан репозиторий [Netology_Diplom_TestApp](https://github.com/MustWay-byte/Netology_Diplom_TestApp) |
| **Простой nginx конфиг, отдающий статические данные** | Файлы `index.html` и `nginx.conf` присутствуют в репозитории |
| **Самостоятельно созданный Dockerfile** | Файл `app/Dockerfile` написан с нуля |
| **Registry с собранным docker image** | Образы `v1` и `latest` успешно собраны и отправлены (`docker push`) |
| **Registry создан/управляется с помощью Terraform** | Ресурс описан в `infra/registry.tf` и импортирован в state (`terraform import`) |

## Скриншоты

**Список образов**

<img width="1839" height="295" alt="image" src="https://github.com/user-attachments/assets/eddefb0c-285c-4007-b3ca-94681a009826" />


---
<img width="1847" height="867" alt="image" src="https://github.com/user-attachments/assets/3bf5571c-5af6-460f-9fee-d8869fa7fc54" />
