**Дипломная работа**

# Kubernetes в Yandex Cloud — Подготовка инфраструктуры через Terraform

Предварительная подготовка к установке и запуску Kubernetes-кластера в Yandex Cloud:
сервисный аккаунт для Terraform, S3-backend для state-файла и базовая сеть (VPC + подсети в трёх зонах доступности).

1. **`bootstrap/`** — «стартовая» конфигурация. Создаёт сервисный аккаунт `bucket-sa`
   с ролью `storage.admin` на каталог (минимально достаточные права для работы с Object Storage,
   **не** `admin`/`editor` на облако), статический ключ доступа для него и S3-бакет
   `mustway-tfstate-bucket-2026` для хранения state-файла. State самой bootstrap-конфигурации
   хранится локально (классическая проблема «курицы и яйца» — бакет для state создаётся этой же конфигурацией).
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

### Сервисный аккаунт и бакет (`bootstrap/main.tf`)

```hcl
resource "yandex_iam_service_account" "bucket_sa" {
  name        = "bucket-sa"
  description = "Service account for S3 backend (Terraform state)"
}

resource "yandex_resourcemanager_folder_iam_member" "bucket_sa_role" {
  folder_id = var.folder_id
  role      = "storage.admin"          # достаточные права, без суперпользователя
  member    = "serviceAccount:${yandex_iam_service_account.bucket_sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "bucket_sa_key" {
  service_account_id = yandex_iam_service_account.bucket_sa.id
  description        = "Static access key for bucket-sa"
  depends_on         = [yandex_resourcemanager_folder_iam_member.bucket_sa_role]
}

resource "yandex_storage_bucket" "tfstate" {
  bucket     = "mustway-tfstate-bucket-2026"   # глобально уникальное имя
  access_key = yandex_iam_service_account_static_access_key.bucket_sa_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket_sa_key.secret_key
  max_size   = 1073741824                      # 1 GB
}
```

### S3-backend (`infra/providers.tf`)

```hcl
terraform {
  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    bucket   = "mustway-tfstate-bucket-2026"
    region   = "ru-central1"
    key      = "infra/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
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

---

## 🚀 Порядок запуска (с нуля)

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

## ✅ Результаты

| Требование | Статус |
|---|---|
| Сервисный аккаунт с достаточными правами (не суперпользователь) | ✅ `bucket-sa`, роль `storage.admin` на каталог |
| Backend — S3-бакет, созданный через Terraform | ✅ `mustway-tfstate-bucket-2026` |
| Разные папки для bootstrap и основной конфигурации | ✅ `bootstrap/` и `infra/` |
| VPC с подсетями в разных зонах доступности | ✅ 3 подсети: `ru-central1-a/b/d` |
| State основной конфигурации в бакете | ✅ `s3://mustway-tfstate-bucket-2026/infra/terraform.tfstate` |
| `destroy` / `apply` без ручных действий | ✅ проверено циклом destroy → apply → plan (no changes) |

Конфигурация предварительная и будет расширяться на следующих шагах (Kubernetes-кластер).

## 🔒 Безопасность: что НЕ коммитить

В репозиторий не должны попасть:

- `key.json` — авторизованный ключ сервисного аккаунта;
- `*.tfstate*` — state содержит секреты (в т.ч. `secret_key` в открытом виде);
- `terraform.tfvars` — значения переменных окружения пользователя;
- `.terraform/` — скачанные провайдеры;
- `/tmp/tfstate-backend.json` — выгруженные outputs с ключами (вне репозитория, но не публикуем).

`.gitignore` для корня репозитория:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
crash.log
crash.*.log
key.json
*.key.json
terraform.tfvars
*.auto.tfvars
override.tf
override.tf.json
*_override.tf
tfstate-backend.json
```

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
