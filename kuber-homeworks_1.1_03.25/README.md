# Задание 1. Установка MicroK8S

## 1. Установка MicroK8S

На виртуальной машине Ubuntu был установлен MicroK8S. Для управления кластером без sudo текущий пользователь добавлен в группу `microk8s`. После запуска кластер перешёл в состояние `running`.

<img width="888" height="596" alt="image" src="https://github.com/user-attachments/assets/a3655429-4880-4b4a-bda5-a668446da6aa" />

## 2. Установка Dashboard

Был включён аддон `dashboard`, а также `dns`, `ingress` и `storage`. Создан административный ServiceAccount и назначена роль `cluster-admin`. Сгенерирован токен для входа в Dashboard. Для доступа к веб-интерфейсу использован `port-forward`, который пробрасывает порт Dashboard на внешний интерфейс. Dashboard доступен по адресу `https://<IP-адрес-ВМ>:10443`.

<img width="1845" height="1758" alt="image" src="https://github.com/user-attachments/assets/f765a809-f42d-4127-96c6-f58c47c35400" />

## 3. Генерация сертификата для подключения к внешнему IP-адресу

Был сгенерирован самоподписанный SSL-сертификат с указанием внешнего IP в поле Subject Alternative Name (SAN). Сертификат и ключ помещены в Secret `kubernetes-dashboard-certs`, после чего под Dashboard перезапущен для применения нового сертификата. Теперь при обращении к Dashboard по IP не возникает ошибки несовпадения имени сертификата, хотя браузер всё ещё предупреждает о недоверенном самоподписанном центре.

<img width="1710" height="1004" alt="image" src="https://github.com/user-attachments/assets/ab33d459-0357-411f-9179-eff12bcf882e" />

## Итог

- MicroK8S успешно запущен.
- Dashboard установлен и доступен.
- Сертификат с SAN сгенерирован и применён.
- Вход в Dashboard выполняется по токену администратора.

