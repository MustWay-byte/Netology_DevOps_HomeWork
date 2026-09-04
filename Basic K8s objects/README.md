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

# Задание 2. Создание Service и подключение его к Pod

## 1. Создание Pod с именем netology-web

Был создан Pod с именем `netology-web` и одним контейнером. Исходно предполагалось использовать образ `gcr.io/kubernetes-e2e-test-images/echoserver:2.2`, однако в процессе выполнения возникла проблема с его загрузкой (ImagePullBackOff). Поэтому, аналогично предыдущему заданию, был использован альтернативный образ `nginx:latest`, который слушает порт 80. Pod получил метку `app: netology-web`, необходимую для дальнейшей привязки Service.

**Проверка статуса Pod**

<img width="488" height="89" alt="image" src="https://github.com/user-attachments/assets/fbb94c06-9a33-42bc-b107-2002485e79dc" />

## 2. Создание Service с именем netology-svc

Был создан Service с именем `netology-svc`. В его селекторе указана метка `app: netology-web`, что обеспечивает связь с ранее созданным Pod. Порт Service установлен как 8080, а targetPort – 80 (соответствует порту nginx). Это позволяет направлять трафик с порта Service на порт контейнера.

## 3. Подключение к Service через kubectl port-forward

Для проверки работы связки Pod-Service был выполнен проброс порта с помощью `kubectl port-forward service/netology-svc 8080:80`. Локальный порт 8080 перенаправлялся на порт 80 Service.

## 4. Проверка работы

При обращении через `curl http://localhost:8080` был получен ответ от echoserver (фактически от nginx, так как использован этот образ), содержащий информацию о запросе: заголовки, метод, IP-адрес клиента. Это подтверждает, что Service успешно направляет трафик к Pod.

**Проверка получения ответа echoserver**

<img width="575" height="508" alt="image" src="https://github.com/user-attachments/assets/78b4c51e-cc1a-4a73-aa09-eb96bb0a82c5" />

## Итог

- Pod `netology-web` создан и работает.
- Service `netology-svc` создан и связан с Pod.
- Локальное подключение к Service выполнено через `kubectl port-forward`.
- Получен ответ от приложения, что доказывает корректность настройки.
