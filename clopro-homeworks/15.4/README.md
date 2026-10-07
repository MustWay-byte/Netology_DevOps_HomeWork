## Задание 1. Yandex Cloud.

Создана security group `mysql-security-group` с правилами:
- Ingress TCP 3306 (MySQL);
- Egress ANY.

### Кластер MySQL

Создан кластер `netology-mysql-cluster` со следующими параметрами:

| Параметр | Значение |
|---|---|
| Окружение | `PRESTABLE` |
| Версия MySQL | `8.0` |
| Пресет | `b1.medium` (Intel Broadwell, 50% CPU, 4 ГБ RAM) |
| Тип диска | `network-ssd` |
| Размер диска | 20 ГБ |
| Время резервного копирования | 23:59 |
| Окно обслуживания | суббота, 03:00 |
| Защита от удаления | включена |
| Количество хостов | 3 |

Хосты размещены в разных подсетях для отказоустойчивости. Из-за ограничения Yandex Cloud — в зоне `ru-central1-d` недоступен пресет `b1.medium` — два хоста оказались в `ru-central1-a` и один в `ru-central1-b`. Это сохраняет отказоустойчивость: при падении одной зоны кластер продолжает работу на второй.

### База данных и пользователь

Создана БД `netology_db` и пользователь `netology_user` с правами `ALL` на неё.

**Список хостов**

<img width="1200" height="274" alt="image" src="https://github.com/user-attachments/assets/0d5b86d3-9177-41f4-8ff8-074df8a52026" />

**Параметры кластера**

<img width="1122" height="590" alt="image" src="https://github.com/user-attachments/assets/089d18f3-119c-4934-b1e3-8c0c232f2ac2" />

<img width="267" height="133" alt="image" src="https://github.com/user-attachments/assets/0996a036-fd46-4db6-ad1c-133246276967" />

**Веб-интерфейс кластера**

<img width="1135" height="209" alt="image" src="https://github.com/user-attachments/assets/e95f260e-9fc5-40f8-a055-ea15a8575ef6" />

Создана сеть `k8s-network` и три подсети в разных зонах доступности:

- `k8s-subnet-a` — 10.20.1.0/24, зона `ru-central1-a`;
- `k8s-subnet-b` — 10.20.2.0/24, зона `ru-central1-b`;
- `k8s-subnet-d` — 10.20.3.0/24, зона `ru-central1-d`.

Размещение подсетей в трёх зонах обеспечивает отказоустойчивость кластера.

### Сервисный аккаунт

Создан сервисный аккаунт `k8s-cluster-sa` с ролями:

- `k8s.clusters.agent` — управление кластером;
- `vpc.publicAdmin` — работа с публичными IP;
- `logging.writer` — отправка логов;
- `kms.keys.encrypterDecrypter` — использование KMS-ключа для шифрования секретов;
- `load-balancer.admin` — создание Network Load Balancer для сервисов типа LoadBalancer.

### KMS-шифрование секретов

Создан симметричный KMS-ключ `k8s-secrets-key` с алгоритмом `AES_256` и периодом ротации 1 год. Ключ подключён к кластеру через блок `kms_provider` — все секреты Kubernetes автоматически шифруются этим ключом.

### Региональный мастер

Мастер развёрнут в трёх зонах доступности (`ru-central1-a`, `ru-central1-b`, `ru-central1-d`) с публичным endpoint. Версия Kubernetes 1.33, release channel STABLE.

### Группа узлов

Создана группа узлов `k8s-node-group` с автомасштабированием:

- min: 3
- max: 6
- initial: 3

Все узлы в зоне `ru-central1-a` (ограничение Yandex Cloud: `auto_scale` работает только в одной зоне). Платформа `standard-v3`, 2 vCPU, 4 ГБ RAM, диск 30 ГБ SSD.

## MySQL и phpMyAdmin

MySQL-кластер `netology-mysql-cluster` из предыдущего задания получил публичный доступ на всех хостах. Публичный IP мастера: `158.160.47.84`.

В Kubernetes развёрнут phpMyAdmin через Deployment с образом `phpmyadmin/phpmyadmin` и следующими переменными окружения:

| Переменная | Значение |
|---|---|
| `PMA_HOST` | `158.160.47.84` (публичный IP мастера MySQL) |
| `PMA_PORT` | `3306` |

Service типа `LoadBalancer` получил публичный IP `158.160.240.232`.

## Проверка

Три ноды кластера Kubernetes находятся в статусе `Ready`. Публичный IP сервиса phpMyAdmin — `158.160.240.232`, под phpMyAdmin работает в статусе `Running`.

Браузер открывает `http://158.160.240.232` — форма входа phpMyAdmin. После входа в левой панели отображается БД `netology_db`.

**Поды и ноды**

<img width="969" height="475" alt="image" src="https://github.com/user-attachments/assets/26bdf84d-e10f-41f5-80d9-6fb10ba43c90" />

**Подключение к phpMyAdmin**
<img width="1842" height="666" alt="image" src="https://github.com/user-attachments/assets/2b64ba47-6cdf-4637-a3b9-ec8c864d60b2" />
