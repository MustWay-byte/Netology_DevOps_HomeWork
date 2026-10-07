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
