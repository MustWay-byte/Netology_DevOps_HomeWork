# Дипломный практикум в Yandex Cloud

**Профессия «DevOps-инженер» · Netology**

Подготовка облачной инфраструктуры, развёртывание Kubernetes-кластера, тестового приложения,
системы мониторинга и полностью автоматизированных CI/CD-пайплайнов — всё в Yandex Cloud,
всё через код (Terraform + Ansible + Helm + GitHub Actions).

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.36.4-326CE5?logo=kubernetes&logoColor=white)
![Kubespray](https://img.shields.io/badge/Kubespray-v2.32.0-EE0000?logo=ansible&logoColor=white)
![Yandex Cloud](https://img.shields.io/badge/Yandex-Cloud-5282FF?logo=yandex&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-2088FF?logo=githubactions&logoColor=white)

---

## Содержание

1. [О проекте: цели, стек, репозитории](#о-проекте)
2. [Этап 1. Создание облачной инфраструктуры](#этап-1-создание-облачной-инфраструктуры)
3. [Этап 2. Создание Kubernetes-кластера](#этап-2-создание-kubernetes-кластера)
4. [Этап 3. Создание тестового приложения](#этап-3-создание-тестового-приложения)
5. [Этап 4. Мониторинг и деплой приложения](#этап-4-подготовка-системы-мониторинга-и-деплой-приложения)
6. [Этап 5. Установка и настройка CI/CD](#этап-5-установка-и-настройка-cicd)

---

## О проекте

### Цели

- Подготовить облачную инфраструктуру в Яндекс.Облаке при помощи Terraform.
- Запустить и сконфигурировать Kubernetes-кластер (self-hosted, Kubespray).
- Установить и настроить систему мониторинга (kube-prometheus-stack).
- Автоматизировать сборку тестового приложения в Docker-образ.
- Настроить CI (сборка при коммите) и CD (деплой при создании тега).
- Автоматизировать применение самой инфраструктуры через Terraform-пайплайн.

### Итоговая архитектура

```
                        Интернет
                           │
        ┌──────────────────┼──────────────────────┐
        │ :80 (Ingress)    │ :6443 (API)          │ :22 (SSH)
        ▼                  ▼                      ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  k8s-master-1   │ │  k8s-worker-1   │ │  k8s-worker-2   │
│  ru-central1-a  │ │  ru-central1-d  │ │  ru-central1-e  │
│  10.20.1.14     │ │  10.20.3.33     │ │  10.20.4.24     │
│  control-plane  │ │  worker         │ │  worker         │
│  + etcd         │ │                 │ │                 │
└────────┬────────┘ └────────┬────────┘ └────────┬────────┘
         └───────────────────┼───────────────────┘
                    VPC k8s-network (Calico VXLAN)
         подсети: a 10.20.1.0/24 · b 10.20.2.0/24 · d 10.20.3.0/24 · e 10.20.4.0/24
                           │
              ┌────────────┴─────────────┐
              ▼                          ▼
   S3: mustway-tfstate-bucket-2026   cr.yandex/crpudopro8jpj70h8dn0
   (state Terraform)                 (Container Registry, образы test-app)

   GitHub Actions: terraform.yml (инфраструктура) · cd-app.yml (приложение)
```

### Технологический стек

| Слой | Технология | Версия / детали |
|---|---|---|
| Облако | Yandex Cloud | Compute Cloud, VPC, Object Storage, Container Registry, IAM |
| IaC | Terraform + провайдер `yandex-cloud/yandex` | backend S3 (Object Storage), state в бакете |
| Kubernetes | Kubespray (Ansible) | v2.32.0 → Kubernetes **v1.36.4**, containerd **2.3.5**, CNI Calico (VXLAN) |
| ОС нод | Ubuntu | 24.04.5 LTS |
| Мониторинг | Helm chart `kube-prometheus-stack` | Prometheus, Grafana, Alertmanager, node-exporter, kube-state-metrics |
| Ingress | Helm chart `ingress-nginx` | DaemonSet + `hostNetwork: true` (порт 80 прямо на нодах, без LoadBalancer) |
| Приложение | nginx + статика | образ `nginx:1.25-alpine`, ~19.5 MB |
| CI/CD | GitHub Actions | `terraform.yml` (инфраструктура), `cd-app.yml` (приложение) |

### Репозитории

| Репозиторий | Содержимое |
|---|---|
| [Netology_DevOps_HomeWork](https://github.com/MustWay-byte/Netology_DevOps_HomeWork/tree/main/devops-diplom-yandexcloud) | Terraform (`bootstrap/`, `infra/`), Ansible/Kubespray, манифесты `k8s/`, скрипты, workflow `terraform.yml` |
| [Netology_Diplom_TestApp](https://github.com/MustWay-byte/Netology_Diplom_TestApp) | Тестовое приложение (`app/`: Dockerfile, nginx.conf, index.html), workflow `cd-app.yml` |

### Доступ к сервисам (учебный стенд)

| Сервис | URL | Учётные данные |
|---|---|---|
| Тестовое приложение | http://84.201.173.154/ | — |
| Grafana | http://84.201.173.154/grafana/ | логин `admin`, пароль `netology-diplom-2026` |
| Kubernetes API | `https://84.201.173.154:6443` | kubeconfig `~/.kube/config` |

> [!NOTE]
> Grafana и приложение доступны по HTTP на **80 порту** через единый Ingress на публичных IP нод.
> Пароль Grafana опубликован намеренно — этого требует задание (ссылка + данные доступа).
> В рабочей среде пароль хранится только в Kubernetes Secret (см. [этап 4](#этап-4-подготовка-системы-мониторинга-и-деплой-приложения)).

---

## Этап 1. Создание облачной инфраструктуры

### Задача

- Сервисный аккаунт для Terraform с необходимыми и достаточными правами (без суперпользователя).
- Backend для Terraform: S3-бакет в Yandex Object Storage, **созданный через Terraform**.
- Конфигурации SA/бакета и основной инфраструктуры — в разных папках.
- VPC с подсетями в разных зонах доступности.
- `terraform destroy` и `terraform apply` — без дополнительных ручных действий.

### Реализация

Проект разделён на две независимые конфигурации:

1. **`bootstrap/`** — «стартовая» конфигурация. Создаёт сервисный аккаунт `bucket-sa`
   с ролью `storage.admin` на каталог (минимально достаточные права для Object Storage,
   **не** `admin`/`editor` на облако), статический ключ доступа и S3-бакет
   `mustway-tfstate-bucket-2026` для state-файлов. State самой bootstrap-конфигурации
   хранится локально — классическая проблема «курицы и яйца»: бакет для state создаётся этой же конфигурацией.
2. **`infra/`** — основная конфигурация. Использует бакет как `backend "s3"`, создаёт VPC,
   подсети, security group, ВМ кластера и Container Registry. State — в бакете.

Аутентификация провайдера — по авторизованному ключу `key.json` сервисного аккаунта
`terraform-sa` (ключ **не** попадает в репозиторий). Ключи доступа к бакету передаются через
переменные окружения `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` (из outputs bootstrap) — в коде секретов нет.

#### Структура проекта

```
devops-diplom-yandexcloud/
├── bootstrap/                  # сервисный аккаунт, статический ключ, S3-бакет
│   ├── providers.tf            # провайдер yandex-cloud/yandex (>= 0.131.0)
│   ├── variables.tf            # cloud_id, folder_id
│   ├── terraform.tfvars        # значения переменных (не коммитится)
│   ├── main.tf                 # SA + роль storage.admin + static key + bucket
│   ├── outputs.tf              # bucket_name, access_key, secret_key (sensitive)
│   └── key.json                # ключ terraform-sa (не коммитится!)
├── infra/                      # основная инфраструктура, state в S3
│   ├── providers.tf            # провайдер + backend "s3"
│   ├── variables.tf            # cloud_id, folder_id, ssh_public_key, preemptible
│   ├── main.tf                 # VPC + подсети a/b/d
│   ├── subnet_e.tf             # подсети зоны e (добавлена на этапе 2)
│   ├── security.tf             # security group кластера
│   ├── compute.tf              # 3 ВМ Kubernetes
│   ├── registry.tf             # Container Registry
│   ├── outputs.tf              # IP нод, registry_id
│   └── key.json                # (не коммитится!)
├── k8s/                        # манифесты Kubernetes (этапы 4–5)
│   ├── monitoring/values.yaml
│   ├── test-app/deployment.yaml
│   └── ingress.yaml
├── scripts/make_inventory.sh   # генерация inventory Kubespray из terraform output
└── .github/workflows/terraform.yml
```

#### Сервисный аккаунт и бакет (`bootstrap/main.tf`)

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
  depends_on         = [yandex_resourcemanager_folder_iam_member.bucket_sa_role]
}

resource "yandex_storage_bucket" "tfstate" {
  bucket     = "mustway-tfstate-bucket-2026"
  access_key = yandex_iam_service_account_static_access_key.bucket_sa_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket_sa_key.secret_key
  max_size   = 1073741824              # 1 GB — state занимает килобайты
}
```

#### S3-backend (`infra/providers.tf`)

```hcl
terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket         = "mustway-tfstate-bucket-2026"
    region         = "ru-central1"
    key            = "infra/terraform.tfstate"
    use_path_style = true

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
```

#### Сеть

| Ресурс | Имя | Зона доступности | CIDR |
|---|---|---|---|
| `yandex_vpc_network.k8s_net` | `k8s-network` | — | — |
| `yandex_vpc_subnet.subnet_a` | `k8s-subnet-a` | `ru-central1-a` | `10.20.1.0/24` |
| `yandex_vpc_subnet.subnet_b` | `k8s-subnet-b` | `ru-central1-b` | `10.20.2.0/24` |
| `yandex_vpc_subnet.subnet_d` | `k8s-subnet-d` | `ru-central1-d` | `10.20.3.0/24` |
| `yandex_vpc_subnet.subnet_e` | `k8s-subnet-e` | `ru-central1-e` | `10.20.4.0/24` |

### Порядок запуска

```bash
# 1. Bootstrap — SA, ключи, бакет
cd bootstrap
terraform init
terraform apply -auto-approve          # Apply complete! Resources: 4 added
terraform output -json > /tmp/tfstate-backend.json

# 2. Infra — backend + сеть
cd ../infra
export AWS_ACCESS_KEY_ID=$(jq -r .access_key.value /tmp/tfstate-backend.json)
export AWS_SECRET_ACCESS_KEY=$(jq -r .secret_key.value /tmp/tfstate-backend.json)
terraform init                         # Successfully configured the backend "s3"!
terraform apply -auto-approve

# 3. Проверка воспроизводимости
terraform destroy -auto-approve        # Destroy complete! Resources: 4 destroyed
terraform apply   -auto-approve        # Apply complete! Resources: 4 added
terraform plan                       # No changes. Infrastructure matches configuration.
```

Обе команды проходят **без ручных действий**: ключи backend — из окружения, ключ провайдера —
из `key.json`, state автоматически читается/пишется в `s3://mustway-tfstate-bucket-2026/infra/terraform.tfstate`.

> [!NOTE]
> `terraform destroy` в `infra/` удаляет только ресурсы основной конфигурации — бакет со state
> остаётся, т.к. управляется отдельной конфигурацией `bootstrap/`.
> Полная очистка: сначала `destroy` в `infra/`, затем в `bootstrap/`.

### Результаты

| Требование | Статус |
|---|---|
| Сервисный аккаунт с достаточными правами (не суперпользователь) | ✅ `bucket-sa`, роль `storage.admin` на каталог |
| Backend — S3-бакет, созданный через Terraform | ✅ `mustway-tfstate-bucket-2026` |
| Разные папки для bootstrap и основной конфигурации | ✅ `bootstrap/` и `infra/` |
| VPC с подсетями в разных зонах доступности | ✅ 4 подсети: `ru-central1-a/b/d/e` |
| State основной конфигурации в бакете | ✅ `s3://mustway-tfstate-bucket-2026/infra/terraform.tfstate` |
| `destroy` / `apply` без ручных действий | ✅ проверено циклом destroy → apply → plan (no changes) |

### Скриншоты

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

---

## Этап 2. Создание Kubernetes-кластера

### Задача

- Минимум 3 ВМ Compute Cloud через Terraform; тип — с учётом производительности и стоимости;
  смена типа инстанса — через Terraform.
- Ansible-конфигурация (Kubespray) и деплой Kubernetes на подготовленные инстансы.
- Доступ к ресурсам из Интернета.
- Работоспособный кластер, `~/.kube/config`, `kubectl get pods --all-namespaces` без ошибок.

Выбран **рекомендуемый вариант — самостоятельная установка** (Kubespray), т.к. он даёт полный
контроль над кластером и не требует оплаты managed-мастера.

### Архитектура и ресурсы

| Нода | Зона | Подсеть | vCPU / RAM | Диск | Внутренний IP | Публичный IP |
|---|---|---|---|---|---|---|
| `k8s-master-1` | `ru-central1-a` | `k8s-subnet-a` | 2 / 4 GB, 100% | 20 GB HDD | `10.20.1.14` | `84.201.173.154` |
| `k8s-worker-1` | `ru-central1-d` | `k8s-subnet-d` | 2 / 4 GB, 100% | 20 GB HDD | `10.20.3.33` | `153.51.161.212` |
| `k8s-worker-2` | `ru-central1-e` | `k8s-subnet-e` | 2 / 4 GB, 100% | 20 GB HDD | `10.20.4.24` | `93.77.161.235` |

**Обоснование конфигурации:**

- **2 vCPU / 4 GB** — минимум kubeadm для control-plane (2 CPU / 2 GB); 4 GB дают запас для etcd и системных подов.
- **`core_fraction = 100`** на мастере — etcd чувствителен к гарантированной доле CPU.
- **`network-hdd`** — квоты аккаунта на `network-ssd` исчерпаны (см. troubleshooting); для учебного стенда HDD достаточно.
- **Зоны `a` / `d` / `e`** — зона `ru-central1-b` закрыта для новых ВМ в этом аккаунте; подсеть в `b` при этом существует (требование этапа 1 выполнено).
- **`allow_stopping_for_update = true`** — смена типа инстанса/диска выполняется через `terraform apply` без ручных действий.
- **`nat = true`** — публичный IP на каждой ноде: доступ из Интернета к API/NodePort/Ingress и выход нод в Интернет за образами.
- Переменная **`preemptible`** вынесена в `variables.tf` — прерываемые ВМ включаются одним `terraform apply` (см. [экономию ресурсов](#экономия-ресурсов-и-безопасность)).

Версии: **Kubernetes v1.36.4**, **containerd 2.3.5**, **Calico (VXLAN)**, Ubuntu 24.04.5 LTS, Kubespray **v2.32.0**.

### Security Group (`infra/security.tf`)

```hcl
resource "yandex_vpc_security_group" "k8s_sg" {
  name       = "k8s-sg"
  network_id = yandex_vpc_network.k8s_net.id

  ingress { description = "SSH";              protocol = "TCP"; port = 22;    v4_cidr_blocks = ["0.0.0.0/0"] }
  ingress { description = "Kubernetes API";   protocol = "TCP"; port = 6443;  v4_cidr_blocks = ["0.0.0.0/0"] }
  ingress { description = "HTTP (Ingress)";   protocol = "TCP"; port = 80;    v4_cidr_blocks = ["0.0.0.0/0"] }
  ingress { description = "NodePort services"; protocol = "TCP"; from_port = 30000; to_port = 32767; v4_cidr_blocks = ["0.0.0.0/0"] }
  ingress { description = "Internal cluster traffic"; protocol = "ANY"; from_port = 0; to_port = 65535; predefined_target = "self_security_group" }
  ingress { description = "ICMP (debug)";     protocol = "ICMP"; v4_cidr_blocks = ["0.0.0.0/0"] }
  egress  { description = "Allow all outbound"; protocol = "ANY"; from_port = 0; to_port = 65535; v4_cidr_blocks = ["0.0.0.0/0"] }
}
```

Правило `self_security_group` разрешает весь внутренний трафик между нодами (Calico VXLAN, etcd, kubelet),
egress ANY обеспечивает выход в Интернет. Порт 80 добавлен на этапе 4 для Ingress — тоже через Terraform.

### Kubespray: inventory и ключевые настройки

Inventory **генерируется автоматически** из `terraform output` скриптом `scripts/make_inventory.sh`
(никаких IP, вписанных руками): `ansible_host` — публичные IP (SSH), `ip` — внутренние (трафик нод внутри VPC).

```ini
[all]
k8s-master-1 ansible_host=<public> ip=10.20.1.14 etcd_member_name=etcd1
k8s-worker-1 ansible_host=<public> ip=10.20.3.33
k8s-worker-2 ansible_host=<public> ip=10.20.4.24

[kube_control_plane]
k8s-master-1
[etcd]
k8s-master-1
[kube_node]
k8s-worker-1
k8s-worker-2
[k8s_cluster:children]
kube_control_plane
kube_node
```

Override-файлы `group_vars/*/yc-overrides.yml`, адаптирующие Kubespray под Yandex Cloud:

```yaml
# group_vars/k8s_cluster/yc-overrides.yml
supplementary_addresses_in_ssl_keys: ["84.201.173.154"]  # публичный IP в SAN сертификата API
calico_ipip_mode: "Never"        # Yandex VPC не пропускает IPIP (IP proto 4)
calico_vxlan_mode: "Always"      # работает VXLAN (UDP 4789)
kubeconfig_localhost: true       # admin.conf -> inventory/mycluster/artifacts/
kubectl_localhost: true          # бинарь kubectl той же версии -> artifacts/
```

```yaml
# group_vars/all/yc-overrides.yml — зеркало Docker Hub (docker.io отдаёт 403 с российских IP)
containerd_registries_mirrors:
  - prefix: "docker.io"
    mirrors:
      - host: "https://mirror.gcr.io"
        capabilities: ["pull", "resolve"]
```

### Деплой и настройка доступа

```bash
# Подготовка (Ubuntu 22.04: ansible-core 2.19 требует Python >= 3.11)
sudo add-apt-repository -y ppa:deadsnakes/ppa && sudo apt-get install -y python3.11 python3.11-venv
ssh-keygen -t rsa -b 4096 -f ~/.ssh/k8s_rsa -N ""

# Terraform: SG + 3 ВМ
cd infra && terraform apply -auto-approve

# Kubespray
git clone --branch v2.32.0 --depth 1 https://github.com/kubernetes-sigs/kubespray.git
cd kubespray && python3.11 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp -rfp inventory/sample inventory/mycluster
../scripts/make_inventory.sh
ansible -i inventory/mycluster/inventory.ini all -m ping          # 3x "pong"
ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml -b -v   # failed=0

# kubeconfig
mkdir -p ~/.kube
cp inventory/mycluster/artifacts/admin.conf ~/.kube/config
sed -i "s|server: https://.*:6443|server: https://84.201.173.154:6443|" ~/.kube/config
chmod 600 ~/.kube/config
sudo install -m 0755 inventory/mycluster/artifacts/kubectl /usr/local/bin/kubectl

# Проверка
kubectl get nodes -o wide                 # 3 ноды Ready, v1.36.4
kubectl get pods --all-namespaces         # все Running / Completed
```

Доступ из Интернета проверен тестовым nginx через NodePort: `curl -I http://<worker_public>:<nodeport>` → `HTTP/1.1 200 OK`.

### Результаты

| Требование | Статус |
|---|---|
| Минимум 3 ВМ через Terraform (1 master + 2 worker) | ✅ `k8s-master-1`, `k8s-worker-1`, `k8s-worker-2` |
| ВМ в разных зонах доступности | ✅ `ru-central1-a`, `ru-central1-d`, `ru-central1-e` |
| Смена типа инстанса через Terraform | ✅ `allow_stopping_for_update = true`, проверено перевыпуском ВМ |
| Ansible-конфигурация (Kubespray) | ✅ v2.32.0, inventory генерируется из `terraform output` |
| Работоспособный кластер | ✅ v1.36.4, containerd 2.3.5, Calico VXLAN |
| `~/.kube/config` с доступом к кластеру | ✅ `admin.conf`, публичный IP мастера в SAN сертификата |
| `kubectl get pods --all-namespaces` без ошибок | ✅ все системные поды `Running` |
| Доступ к ресурсам из Интернета | ✅ NodePort: `curl -I` → `HTTP/1.1 200 OK` |

### Скриншоты

**Виртуальные машины**

<img width="1822" height="299" alt="image" src="https://github.com/user-attachments/assets/2c8a1f7a-8557-4bc2-bb16-f40ccc7a62d1" />

**Статус нод кластера**

<img width="1371" height="95" alt="image" src="https://github.com/user-attachments/assets/85c20eee-6ede-44b7-a285-a90283a53ed7" />

**Статус системных подов**

<img width="870" height="330" alt="image" src="https://github.com/user-attachments/assets/8d2dcbeb-76b7-4f58-b3a3-fcd67893d6ee" />

**Доступ к ресурсам из Интернета**

<img width="407" height="200" alt="image" src="https://github.com/user-attachments/assets/85d80ee7-becd-430c-84c7-cd3dc50dc07e" />

---

## Этап 3. Создание тестового приложения

### Задача

- Отдельный git-репозиторий с простым nginx-конфигом, отдающим статику.
- Самостоятельно созданный Dockerfile.
- Registry с собранным образом (Yandex Container Registry, управляемый через Terraform).

### Реализация

Приложение — лёгкий веб-сервер на nginx, эмулирующий основной продукт компании:
отдаёт статическую страницу, упакован в Docker-образ и размещён в приватном реестре Yandex Cloud.

**Репозиторий:** [Netology_Diplom_TestApp](https://github.com/MustWay-byte/Netology_Diplom_TestApp)

```
Netology_Diplom_TestApp/
├── app/
│   ├── Dockerfile        # самостоятельно написанный файл сборки
│   ├── nginx.conf        # кастомный конфиг nginx
│   └── index.html        # статическая страница
└── .github/workflows/cd-app.yml
```

#### Dockerfile (`app/Dockerfile`)

```dockerfile
FROM nginx:1.25-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

#### Container Registry через Terraform (`infra/registry.tf`)

Реестр создан в Yandex Cloud и взят под управление Terraform через `terraform import` —
ресурс описан в коде, идемпотентен и воспроизводим (IaC):

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

```bash
terraform import yandex_container_registry.test_app_registry crpudopro8jpj70h8dn0
```

#### Сборка и публикация образов

```bash
yc container registry configure-docker        # авторизация docker в cr.yandex через yc CLI
export REGISTRY_ID="crpudopro8jpj70h8dn0"

cd app
docker build -t cr.yandex/${REGISTRY_ID}/test-app:v1 .
docker push  cr.yandex/${REGISTRY_ID}/test-app:v1
docker tag   cr.yandex/${REGISTRY_ID}/test-app:v1 cr.yandex/${REGISTRY_ID}/test-app:latest
docker push  cr.yandex/${REGISTRY_ID}/test-app:latest
```

| Параметр | Значение |
|---|---|
| Registry ID | `crpudopro8jpj70h8dn0` |
| Образы | `cr.yandex/crpudopro8jpj70h8dn0/test-app:v1`, `:latest` (далее — теги `v1.0.x` из CI/CD) |
| Размер образа | ~19.5 MB (alpine-база) |

### Результаты

| Требование | Статус |
|---|---|
| Отдельный git-репозиторий с тестовым приложением | ✅ [Netology_Diplom_TestApp](https://github.com/MustWay-byte/Netology_Diplom_TestApp) |
| Простой nginx-конфиг, отдающий статику | ✅ `index.html` + `nginx.conf` в репозитории |
| Самостоятельно созданный Dockerfile | ✅ `app/Dockerfile` написан с нуля |
| Registry с собранным docker image | ✅ образы `v1` и `latest` собраны и отправлены (`docker push`) |
| Registry создан/управляется через Terraform | ✅ `infra/registry.tf`, ресурс в state (`terraform import`) |

### Скриншоты

**Список образов**

<img width="1839" height="295" alt="image" src="https://github.com/user-attachments/assets/eddefb0c-285c-4007-b3ca-94681a009826" />

---

## Этап 4. Подготовка системы мониторинга и деплой приложения

### Задача

- Задеплоить prometheus, grafana, alertmanager, экспортёр основных метрик Kubernetes (kube-prometheus).
- Задеплоить тестовое приложение.
- HTTP-доступ на **80 порту** к Grafana и к приложению; дашборды состояния кластера.
- Git-репозиторий с конфигурационными файлами Kubernetes.
- Деплой инфраструктуры в terraform pipeline (CI/CD вместо Atlantis/Terraform Cloud).

### Архитектура и компоненты

| Компонент | Технология | Namespace | Описание |
|---|---|---|---|
| Prometheus + Grafana + Alertmanager | Helm chart `kube-prometheus-stack` | `monitoring` | полный стек мониторинга и визуализации |
| Node Exporter + kube-state-metrics | в составе `kube-prometheus-stack` | `monitoring` | метрики нод (CPU, RAM, Disk, Network) и объектов K8s |
| Test App | Deployment (2 реплики) + Service | `default` | nginx + статика, образ из Yandex Container Registry |
| Ingress Controller | Helm chart `ingress-nginx`, **DaemonSet + hostNetwork** | `ingress-nginx` | порт 80 напрямую на всех нодах — без платного LoadBalancer |
| Единый Ingress | `main-ingress` + ExternalName-сервис | `monitoring` | маршрутизация `/` → приложение, `/grafana` → Grafana |
| Terraform pipeline | GitHub Actions `terraform.yml` | внешняя среда | `init → fmt → validate → plan → apply` при пуше в `main` |

### Деплой мониторинга (Helm)

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f k8s/monitoring/values.yaml
```

Финальный `k8s/monitoring/values.yaml` — Grafana за subpath, пароль в Kubernetes Secret,
корректные пробы здоровья:

```yaml
grafana:
  admin:
    existingSecret: grafana-admin-credentials   # пароль НЕ в коде
    userKey: admin-user
    passwordKey: admin-password
  service:
    type: ClusterIP
    port: 80
  ingress:
    enabled: false            # управляем единым main-ingress
  grafana.ini:
    server:
      root_url: "http://84.201.173.154/grafana/"
      serve_from_sub_path: true
  readinessProbe:
    httpGet: { path: /grafana/api/health, port: 3000 }
  livenessProbe:
    httpGet: { path: /grafana/api/health, port: 3000 }
prometheus:
  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: false   # видеть все ServiceMonitor'ы
```

```bash
kubectl create secret generic grafana-admin-credentials -n monitoring \
  --from-literal=admin-user=admin \
  --from-literal=admin-password=netology-diplom-2026
```

### Ingress: единая точка входа на 80 порту

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.kind=DaemonSet \
  --set controller.hostNetwork=true
```

`hostNetwork: true` + DaemonSet = контроллер слушает 80/443 **на каждой ноде напрямую**.
Внешний IP не нужен — работает публичный IP любой ноды. Это осознанная экономия:
не создаётся облачный LoadBalancer. Порт 80 открыт в security group через Terraform.

Манифесты в `k8s/`:

```yaml
# k8s/ingress.yaml — единый Ingress (namespace monitoring)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: main-ingress
  namespace: monitoring
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: test-app-external      # ExternalName -> default/test-app-service
            port: { number: 80 }
      - path: /grafana
        pathType: Prefix
        backend:
          service:
            name: monitoring-grafana
            port: { number: 80 }
---
# ExternalName-сервис для доступа к приложению из другого namespace
apiVersion: v1
kind: Service
metadata:
  name: test-app-external
  namespace: monitoring
spec:
  type: ExternalName
  externalName: test-app-service.default.svc.cluster.local
```

Приложение деплоится из `k8s/test-app/deployment.yaml` (Deployment, 2 реплики, образ
`cr.yandex/crpudopro8jpj70h8dn0/test-app`, Service `test-app-service`).
Никаких `rewrite-target` — Grafana сама обрабатывает префикс благодаря `serve_from_sub_path`.

### Terraform pipeline (CI/CD инфраструктуры)

`.github/workflows/terraform.yml` в репозитории инфраструктуры — альтернатива Atlantis/Terraform Cloud:

- **Триггеры:** push в `main` при изменении `devops-diplom-yandexcloud/infra/**` или `bootstrap/**`; ручной `workflow_dispatch`.
- **Шаги:** checkout → `hashicorp/setup-terraform@v3` → установка YC CLI → авторизация по ключу SA
  (секрет `YC_SA_JSON`, валидация JSON через `jq`) → `terraform init` (S3-ключи из секретов) →
  `terraform fmt -check` → `terraform validate` → `terraform plan` → `terraform apply -auto-approve`.
- **Секреты GitHub:** `YC_SA_JSON`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `TF_VAR_cloud_id`,
  `TF_VAR_folder_id`, `TF_VAR_ssh_public_key`. В коде — ни одного секрета.
- **Адаптация под CI:** SSH-ключ передаётся переменной `var.ssh_public_key` (`TF_VAR_ssh_public_key`),
  а не `file()` — на runner'е нет локальных файлов ключей.

### Доступ к сервисам

| Сервис | URL | Учётные данные |
|---|---|---|
| Тестовое приложение | http://84.201.173.154/ | — |
| Grafana | http://84.201.173.154/grafana/ | `admin` / `netology-diplom-2026` |

Проверено: `curl -I http://84.201.173.154/` → `200 OK`; `curl -I http://84.201.173.154/grafana/` → `302` на `/grafana/login`, интерфейс открывается.
Дашборды `Kubernetes / Compute Resources / Cluster` и дашборды нод отображают живые метрики кластера.

### Результаты

| Требование | Статус |
|---|---|
| prometheus, grafana, alertmanager, node_exporter | ✅ Helm `kube-prometheus-stack`, namespace `monitoring` |
| Тестовое приложение задеплоено | ✅ Deployment `test-app`, 2 реплики, образ из YC Registry |
| Git-репозиторий с конфигурациями K8s | ✅ `k8s/monitoring/values.yaml`, `k8s/test-app/deployment.yaml`, `k8s/ingress.yaml` |
| HTTP :80 к Grafana | ✅ `http://84.201.173.154/grafana/` через единый Ingress |
| Дашборды состояния кластера | ✅ встроенные дашборды kube-prometheus-stack активны |
| HTTP :80 к тестовому приложению | ✅ `http://84.201.173.154/` через Ingress |
| ci/cd-terraform (вместо Atlantis) | ✅ GitHub Actions workflow, скриншоты работы пайплайна ниже |

### Скриншоты

**Тестовое приложение**

<img width="1847" height="867" alt="image" src="https://github.com/user-attachments/assets/3bf5571c-5af6-460f-9fee-d8869fa7fc54" />

**Дашборды Grafana**

<img width="1847" height="832" alt="image" src="https://github.com/user-attachments/assets/d36f897e-410b-4d5f-9656-46306728486b" />

<img width="1850" height="715" alt="image" src="https://github.com/user-attachments/assets/2f52c63b-aba0-4584-970b-cb25175bf31d" />

<img width="1846" height="707" alt="image" src="https://github.com/user-attachments/assets/4c598e5b-ae18-4c7d-9e45-9d9fac808e8d" />

<img width="1846" height="835" alt="image" src="https://github.com/user-attachments/assets/94fd80f0-c817-4c0d-9e3f-dd2a13126042" />

**Статус подов в кластере**

<img width="979" height="595" alt="image" src="https://github.com/user-attachments/assets/230d3438-d5d2-48ec-8e19-9e3ad9169f81" />

**Работа пайплайна**

<img width="1872" height="705" alt="image" src="https://github.com/user-attachments/assets/98e92920-1201-412a-a304-7dbda9db83f9" />

<img width="933" height="840" alt="image" src="https://github.com/user-attachments/assets/c0350ad4-af0b-446d-9eef-a619ff1d0a8a" />

---

## Этап 5. Установка и настройка CI/CD

### Задача

- Автоматическая сборка docker-образа при коммите в репозиторий приложения.
- При создании тега (`v1.0.0`) — сборка, отправка с соответствующим label и деплой в кластер.
- Интерфейс CI/CD доступен по HTTP.

### Выбранный инструмент

**GitHub Actions** — нативная интеграция с репозиторием, не нужно поддерживать отдельный
CI-сервер (Jenkins/TeamCity), гибкие триггеры (ветки, теги, пути), безопасное хранение
чувствительных данных в GitHub Secrets. Веб-интерфейс — вкладка **Actions** репозитория (HTTP).

### Архитектура пайплайна (`cd-app.yml`)

Пайплайн живёт в репозитории приложения [Netology_Diplom_TestApp](https://github.com/MustWay-byte/Netology_Diplom_TestApp)
и состоит из двух jobs:

```yaml
on:
  push:
    branches: [main]
    paths: ['app/**']
    tags: ['v*']          # один ключ push: и ветка, и теги

env:
  REGISTRY: cr.yandex
  REGISTRY_ID: crpudopro8jpj70h8dn0
  IMAGE_NAME: test-app
```

**1. `build-and-push`** — при любом коммите в `main` (изменения `app/**`) и при тегах `v*`:

- установка YC CLI, авторизация по ключу SA (`YC_SA_JSON`);
- `IAM_TOKEN=$(yc iam create-token)` → `docker login --username iam --password-stdin cr.yandex`;
- `docker/metadata-action@v5` формирует теги: **sha коммита**, **latest** (для default-ветки), **имя git-тега**;
- `docker/build-push-action@v5` собирает образ из `app/` и пушит в Yandex Container Registry.

**2. `deploy-to-k8s`** — только при тегах `v*` (`if: startsWith(github.ref, 'refs/tags/v')`, `needs: build-and-push`):

- установка kubectl, kubeconfig из секрета `KUBE_CONFIG`;
- `kubectl set image deployment/test-app test-app=cr.yandex/${REGISTRY_ID}/test-app:${{ github.ref_name }} -n default`;
- `kubectl rollout status deployment/test-app` — ожидание успешного раскатывания.

### Проверка на практике

- Тег **v1.0.3**: сборка → пуш → деплой, `deployment "test-app" successfully rolled out`.
- Тег **v1.0.4**: повторный прогон; `kubectl describe pod -l app=test-app` показывает
  `Image: cr.yandex/crpudopro8jpj70h8dn0/test-app:v1.0.4` на **обеих репликах**
  (два образа в выводе — это два пода Deployment'а, а не дубликат).

### Безопасность

В репозитории **нет учётных данных**. Секреты GitHub:

| Секрет | Назначение |
|---|---|
| `YC_SA_JSON` | JSON-ключ сервисного аккаунта (YC CLI, Container Registry) |
| `KUBE_CONFIG` | kubeconfig для подключения к API кластера |

### Результаты

| Требование | Статус |
|---|---|
| Интерфейс CI/CD доступен по HTTP | ✅ вкладка Actions репозитория GitHub |
| При любом коммите — сборка и отправка образа в регистр | ✅ триггер `push` в `main` (`app/**`) → `build-and-push` |
| При теге `v*` — сборка, label и деплой в K8s | ✅ теги `v1.0.3`, `v1.0.4` проверены: образ в кластере обновлён, rollout успешен |

### Скриншоты

**Сборка образа**

<img width="1892" height="686" alt="image" src="https://github.com/user-attachments/assets/58ee6795-0d55-466d-a6d6-ebfb776b0bd2" />

<img width="1319" height="893" alt="image" src="https://github.com/user-attachments/assets/70ba458d-a707-4c58-b8b4-632242c657bb" />

**Деплой образа**

<img width="1885" height="926" alt="image" src="https://github.com/user-attachments/assets/4059065f-492b-4b0c-81df-2140402c2a15" />

**Список задеплоенных образов**

<img width="1188" height="100" alt="image" src="https://github.com/user-attachments/assets/27bbd3fe-3251-4dde-b05c-4a22871a6ee3" />

---

## Заключение

Все пять этапов дипломного практикума выполнены: облачная инфраструктура управляется Terraform
с state в S3-бакете, Kubernetes-кластер развёрнут Kubespray и доступен из Интернета, тестовое
приложение собирается в Docker и живёт в Yandex Container Registry, мониторинг на kube-prometheus-stack
отдаёт дашборды и приложение по HTTP на 80 порту, а оба CI/CD-пайплайна (инфраструктура и приложение)
автоматически применяют изменения из git.
