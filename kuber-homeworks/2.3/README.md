## Задание 1. Работа с ConfigMaps

Развернуто приложение из двух контейнеров (nginx и multitool). Веб-страница для nginx подключена через ConfigMap, смонтированный в `/usr/share/nginx/html`. Доступность проверена через port-forward и curl.

**Вывод `Curl`**

<img width="708" height="203" alt="image" src="https://github.com/user-attachments/assets/fb0e35b3-0265-4a67-a7d9-78555ec20702" />

## Задание 2. Настройка HTTPS с Secrets

Сгенерирован самоподписанный сертификат, создан Secret типа `kubernetes.io/tls`. Настроен Ingress с TLS для доступа к приложению по HTTPS. Проверка выполнена с помощью `curl -k`.

**Вывод `Curl -k`**

<img width="1176" height="200" alt="image" src="https://github.com/user-attachments/assets/032a1589-1305-4db1-b4ec-62348e449148" />

## Задание 3. Настройка RBAC

Включён RBAC. Создан пользователь `developer` с клиентским сертификатом. Созданы Role и RoleBinding, разрешающие только просмотр подов и их логов. Проверка подтвердила: `kubectl get pods` и `logs` работают, попытки создать под или получить список сервисов возвращают Forbidden.

**Генерация сертификатов**

<img width="1017" height="288" alt="image" src="https://github.com/user-attachments/assets/fe0e94e6-2b44-4ea2-ad3b-85e9283b1bd5" />

**Проверка прав**

<img width="1265" height="287" alt="image" src="https://github.com/user-attachments/assets/86d8bb6b-62c4-403f-a1b4-53268d17203a" />
