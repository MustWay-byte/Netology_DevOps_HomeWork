# Задание 1. Создание Deployment и обеспечение доступа к репликам из другого Pod

## 1. Создание Deployment с двумя контейнерами

Был создан Deployment `netology-deployment` с одной репликой Pod'а, содержащим два контейнера:

- `nginx` (порт 80)
- `multitool` (порт 8080)

Для устранения конфликта портов (оба контейнера по умолчанию используют порт 80) контейнеру multitool была задана переменная окружения `HTTP_PORT=8080`.

## 2. Масштабирование

Изначально Deployment имел 1 реплику. После успешного запуска количество реплик было увеличено до 2 командой `kubectl scale`. Количество подов до и после масштабирования проверено с помощью `kubectl get pods`.

**Поды до масштабирования**

<img width="1281" height="71" alt="image" src="https://github.com/user-attachments/assets/2ff85539-fb46-41a2-84d7-ca43a662d39d" />

**Поды после масштабирования**

<img width="1274" height="122" alt="image" src="https://github.com/user-attachments/assets/4bf3ee6f-f4ff-4fc0-bc98-ee020a162eb1" />

## 3. Создание Service

Для доступа к репликам создан Service `netology-svc-deploy` с селектором по метке `app: netology-deployment` и портом 80 (targetPort 80). Он направляет трафик на nginx-контейнеры.

## 4. Проверка доступа из другого Pod

Создан отдельный Pod `multitool-test` с образом `wbitt/network-multitool`. С помощью `kubectl exec` внутрь него выполнены два HTTP-запроса:

- `curl http://netology-svc-deploy:80` — получена стандартная страница nginx.
- `curl http://10.1.195.234:8080` (IP одного из подов Deployment) — получен ответ от multitool с информацией о контейнере.

Оба запроса подтвердили доступность приложений из другого Pod.

**Успешный доступ до приложений**
<img width="1404" height="573" alt="image" src="https://github.com/user-attachments/assets/a967d633-bafc-4cc6-afa5-5354230fd442" />

## Итог

- Deployment с двумя контейнерами создан, проблема с портами решена.
- Количество реплик увеличено с 1 до 2.
- Service обеспечивает доступ к nginx.
- Проверка доступа из отдельного Pod к обоим контейнерам (nginx и multitool) прошла успешно.
