# Задание 1. Создание Pod с именем hello-world

## 1. Создание манифеста Pod

Был создан Pod с именем `hello-world` и одним контейнером. Изначально предполагалось использовать образ `gcr.io/kubernetes-e2e-test-images/echoserver:2.2`, однако он оказался недоступен (ошибка `ImagePullBackOff`). Поэтому для демонстрации работы Pod и port-forward был использован образ `nginx:latest`, который также слушает порт 80.

## 2. Применение манифеста и запуск Pod

Манифест применён командой `kubectl apply -f hello-world-pod.yaml`. Pod успешно создан и перешёл в состояние `Running`.

**Проверка статуса Pod**

<img width="482" height="74" alt="image" src="https://github.com/user-attachments/assets/a7e14bf8-c425-41a0-83d5-c7a81e94112c" />

## 3. Подключение к Pod через kubectl port-forward

Для доступа к приложению внутри Pod выполнен проброс порта:
`kubectl port-forward --address 127.0.0.1 pod/hello-world 8080:80`

Локальный порт 8080 перенаправлен на порт 80 контейнера.

## 4. Проверка работы

После запуска port-forward выполнен HTTP-запрос:
`curl http://127.0.0.1:8080`

В ответ получена стандартная страница nginx, что подтверждает корректную работу Pod и port-forward.

**Проверка получения страницы nginx**

<img width="890" height="705" alt="image" src="https://github.com/user-attachments/assets/619388c9-4d70-4c54-84b4-2a5e076714d5" />

## Итог

- Pod `hello-world` создан и запущен.
- Подключение к Pod выполнено с помощью `kubectl port-forward`.
- Получен ответ от приложения.
- Вместо образа `gcr.io/kubernetes-e2e-test-images/echoserver:2.2` использован `nginx:latest` из-за недоступности первого; остальные шаги задания выполнены полностью.
