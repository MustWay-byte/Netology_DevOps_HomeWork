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

# Задание 2. Создание Deployment и обеспечение старта основного контейнера при выполнении условий

## 1. Создание Deployment с Init-контейнером

Создан Deployment `netology-init` с одним основным контейнером `nginx` и init-контейнером `busybox`. Init-контейнер в цикле выполнял `nslookup` для проверки доступности сервиса `netology-svc`. Использовано полное DNS-имя `netology-svc.default.svc.cluster.local`, чтобы избежать проблем с короткими именами.

## 2. Состояние до создания Service

Пока Service не был создан, DNS-запись отсутствовала, init-контейнер продолжал ожидание, основной контейнер не запускался. Под имел статус `Init:0/1`, условие `Ready` – `False`.

**Состояние Pod до создания Service**

<img width="947" height="328" alt="image" src="https://github.com/user-attachments/assets/a6eaffc2-6017-47f2-a8a7-244939a1a9cf" />

## 3. Создание Service

Создан Service `netology-svc` с селектором по метке `app: netology-init` и портом 80.

## 4. Состояние после создания Service

После появления Service DNS-запись стала доступной, init-контейнер завершился успешно, и Kubernetes запустил основной контейнер `nginx`. Под перешёл в состояние `Running` (1/1).

**Состояние Pod после создания Service**

<img width="949" height="484" alt="image" src="https://github.com/user-attachments/assets/b9167ad9-17e9-49e0-9393-d889c8e507e4" />

## Итог

Init-контейнер корректно ожидал появления сервиса, после чего основной контейнер стартовал.
