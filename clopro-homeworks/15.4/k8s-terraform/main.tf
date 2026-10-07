# ============================================================
# VPC и три подсети в разных зонах
# ============================================================
resource "yandex_vpc_network" "k8s_net" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s_subnet_a" {
  name           = "k8s-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s_net.id
  v4_cidr_blocks = ["10.20.1.0/24"]
}

resource "yandex_vpc_subnet" "k8s_subnet_b" {
  name           = "k8s-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k8s_net.id
  v4_cidr_blocks = ["10.20.2.0/24"]
}

resource "yandex_vpc_subnet" "k8s_subnet_d" {
  name           = "k8s-subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.k8s_net.id
  v4_cidr_blocks = ["10.20.3.0/24"]
}

# ============================================================
# Сервисный аккаунт для кластера
# ============================================================
resource "yandex_iam_service_account" "k8s_sa" {
  name = "k8s-cluster-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_sa_roles" {
  for_each = toset([
    "k8s.clusters.agent",
    "vpc.publicAdmin",
    "logging.writer",
    "kms.keys.encrypterDecrypter",
  ])
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

# ============================================================
# KMS-ключ для шифрования секретов
# ============================================================
resource "yandex_kms_symmetric_key" "k8s_kms" {
  name              = "k8s-secrets-key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
}

resource "yandex_kms_symmetric_key_iam_member" "k8s_sa_kms" {
  symmetric_key_id = yandex_kms_symmetric_key.k8s_kms.id
  role             = "kms.keys.encrypterDecrypter"
  member           = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

# ============================================================
# Security Group
# ============================================================
resource "yandex_vpc_security_group" "k8s_sg" {
  name       = "k8s-security-group"
  network_id = yandex_vpc_network.k8s_net.id

  ingress {
    description    = "Kubernetes API"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "NodePort services"
    protocol       = "TCP"
    from_port      = 30000
    to_port        = 32767
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Internal cluster communication"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.20.0.0/16"]
  }

  ingress {
    description    = "Health checks"
    protocol       = "TCP"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "All outbound"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ============================================================
# Региональный мастер Kubernetes
# ============================================================
resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name        = "netology-k8s-cluster"
  description = "Regional Kubernetes cluster with KMS encryption"
  network_id  = yandex_vpc_network.k8s_net.id

  master {
    version = "1.33"
    regional {
      region = "ru-central1"

      location {
        zone      = "ru-central1-a"
        subnet_id = yandex_vpc_subnet.k8s_subnet_a.id
      }
      location {
        zone      = "ru-central1-b"
        subnet_id = yandex_vpc_subnet.k8s_subnet_b.id
      }
      location {
        zone      = "ru-central1-d"
        subnet_id = yandex_vpc_subnet.k8s_subnet_d.id
      }
    }

    public_ip = true

    security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
  }

  service_account_id      = yandex_iam_service_account.k8s_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_sa.id

  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s_kms.id
  }

  release_channel = "STABLE"

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_sa_roles,
    yandex_kms_symmetric_key_iam_member.k8s_sa_kms,
  ]
}

# ============================================================
# Группа узлов с автомасштабированием
# ============================================================
resource "yandex_kubernetes_node_group" "k8s_nodes" {
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "k8s-node-group"
  version    = "1.33"

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores  = 2
      memory = 4
    }

    boot_disk {
      type = "network-ssd"
      size = 30
    }

    network_interface {
      subnet_ids         = [yandex_vpc_subnet.k8s_subnet_a.id]
      nat                = true
      security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}

# ============================================================
# Outputs
# ============================================================
output "cluster_id" {
  value = yandex_kubernetes_cluster.k8s_cluster.id
}

output "cluster_endpoint" {
  value = yandex_kubernetes_cluster.k8s_cluster.master[0].external_v4_endpoint
}
