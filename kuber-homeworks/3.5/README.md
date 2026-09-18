# Задание 1. Troubleshooting: web-consumer не может подключиться к auth-db

## Выявленная проблема

Приложение `web-consumer` не могло подключиться к `auth-db`. В логах пода `web-consumer` постоянно повторялась ошибка: curl: (6) Could not resolve host: auth-db

### Причина

Приложения развёрнуты в разных namespace:
- `web-consumer` — в namespace `web`
- `auth-db` (Service) — в namespace `data`

В манифесте приложения `web-consumer` использовалась команда с **коротким DNS-именем** `auth-db`. Kubernetes DNS (CoreDNS) по умолчанию разрешает короткие имена только в пределах namespace текущего пода — то есть `auth-db` искался в namespace `web`, где такого Service нет. Отсюда ошибка разрешения имени.

## Что было сделано

В Deployment `web-consumer` команда обращения к БД была изменена: вместо короткого имени `auth-db` стало использоваться DNS-имя с указанием namespace — `auth-db.data`. Это стандартный способ адресации Service из других namespace в Kubernetes.

## Демонстрация решения

После правки поды `web-consumer` перезапустились и перешли в состояние `Running`. В логах вместо ошибки разрешения имени появился успешный HTML-ответ от nginx:

**Применение патча**

<img width="1088" height="1683" alt="image" src="https://github.com/user-attachments/assets/b8ef73bc-c7cc-4c75-9e2d-9fe8c650a2d6" />
