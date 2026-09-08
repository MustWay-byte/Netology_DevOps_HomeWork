# Задание 1. Настройка Service (ClusterIP и NodePort)

## Выполненные шаги

1. Создан Deployment `multi-container-app` с тремя репликами, состоящими из контейнеров `nginx` (порт 80) и `multitool` (порт 8080). Для избежания конфликта портов multitool была задана переменная окружения `HTTP_PORT=8080`.

2. Создан Service типа ClusterIP `multi-container-clusterip`:
   - порт 9001 направлен на nginx (targetPort 80)
   - порт 9002 направлен на multitool (targetPort 8080)

3. Проверен доступ изнутри кластера:
   - запущен временный Pod `test-pod` на образе `wbitt/network-multitool`
   - внутри пода выполнены `curl http://multi-container-clusterip:9001` и `curl http://multi-container-clusterip:9002`
   - получены ответы от nginx и multitool соответственно

**Доступ изнутри кластера**

<img width="1395" height="582" alt="image" src="https://github.com/user-attachments/assets/92db307b-4d6e-4dec-bbf0-7fa74e555a92" />

4. Создан Service типа NodePort `multi-container-nodeport` с портом 30080 для доступа к nginx.

5. Проверен доступ снаружи через `curl http://192.168.3.28:30080`, получена стандартная страница nginx.

**Доступ снаружи кластера**

<img width="646" height="509" alt="image" src="https://github.com/user-attachments/assets/2205ea9f-509b-4d7e-8a96-fe00d36ce6a2" />

## Манифесты

- `deployment-multi-container.yaml`
- `service-clusterip.yaml`
- `service-nodeport.yaml`

## Результаты проверок

- ClusterIP: успешно получены ответы от обоих контейнеров.
- NodePort: успешно получена страница nginx.

# Задание 2. Настройка Ingress

## Выполненные шаги

1. Включён Ingress-контроллер MicroK8S (`microk8s enable ingress`).
2. Созданы два Deployment:
   - `frontend` (образ nginx, порт 80)
   - `backend` (образ wbitt/network-multitool, порт 80)
3. Созданы два Service:
   - `frontend-svc` (направлен на frontend, порт 80)
   - `backend-svc` (направлен на backend, порт 80 после исправления targetPort)
4. Создан Ingress `example-ingress`, который маршрутизирует:
   - `/` → frontend-svc
   - `/api` → backend-svc

## Проверка доступа

- `curl http://192.168.3.28/` – получена стандартная страница nginx.
- `curl http://192.168.3.28/api` – получен ответ от multitool с информацией о поде.

**Проверка доступности кластера**

<img width="1272" height="559" alt="image" src="https://github.com/user-attachments/assets/a9fc0118-44f9-4919-a15f-041d293b2c19" />

## Манифесты

- `deployment-frontend.yaml`
- `deployment-backend.yaml`
- `service-frontend.yaml`
- `service-backend.yaml`
- `ingress.yaml`

## Итог

Ingress корректно маршрутизирует трафик по разным путям. Оба приложения доступны.
